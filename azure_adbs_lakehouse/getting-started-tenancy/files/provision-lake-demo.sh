#!/usr/bin/env bash
# Run in Azure Cloud Shell (Bash), beside the two SQL files from this lab.
set -euo pipefail
umask 077

[[ $# -eq 4 ]] || {
  echo "Usage: bash provision-lake-demo.sh RESOURCE_GROUP ADBS_NAME STORAGE_ACCOUNT CONTAINER" >&2
  exit 1
}
RESOURCE_GROUP="$1"
ADBS_NAME="$2"
STORAGE_ACCOUNT="$3"
CONTAINER="$4"
SCRIPT_DIRECTORY="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
SQLCL_DIRECTORY="$HOME/lakehouse-tools"
WALLET_DIRECTORY="$HOME/Wallet_${ADBS_NAME}"

for prerequisite in az curl unzip java; do
  command -v "$prerequisite" >/dev/null || {
    echo "$prerequisite is required. Use Azure Cloud Shell in Bash mode." >&2
    exit 1
  }
done
for sql_file in provision-lake-demo.sql load-reference-tables.sql; do
  [[ -f "$SCRIPT_DIRECTORY/$sql_file" ]] || {
    echo "Upload $sql_file beside this script before running it." >&2
    exit 1
  }
done
[[ "$ADBS_NAME" =~ ^[A-Za-z][A-Za-z0-9]{0,29}$ ]] || { echo "Invalid database name." >&2; exit 1; }
[[ "$STORAGE_ACCOUNT" =~ ^[a-z0-9]{3,24}$ ]] || { echo "Invalid storage account name." >&2; exit 1; }
[[ "$CONTAINER" =~ ^[a-z0-9][a-z0-9-]{1,61}[a-z0-9]$ ]] || { echo "Invalid container name." >&2; exit 1; }

# This lab's restricted character set is safe for both CLI and SQLcl substitution.
# The values are read silently, never saved in a source file, and removed on exit.
read_password() {
  local label="$1" value
  while true; do
    read -r -s -p "$label: " value
    printf '\n'
    if [[ "$value" =~ ^[A-Za-z0-9_#!-]{12,30}$ && "$value" =~ [A-Z] && "$value" =~ [a-z] && "$value" =~ [0-9] ]]; then
      printf -v "$2" '%s' "$value"
      break
    fi
    echo "Use 12-30 characters from letters, numbers, _, #, !, or -, including uppercase, lowercase, and a number." >&2
  done
}
trap 'unset ADMIN_PASSWORD LAKE_DEMO_PASSWORD WALLET_PASSWORD AZURE_STORAGE_ACCOUNT_KEY' EXIT
read_password 'Database ADMIN password chosen when creating the database' ADMIN_PASSWORD
read_password 'Choose a LAKE_DEMO password and save it for Lab 1' LAKE_DEMO_PASSWORD
read_password 'Choose a wallet password' WALLET_PASSWORD

mkdir -p "$SQLCL_DIRECTORY" "$WALLET_DIRECTORY"
if [[ ! -x "$SQLCL_DIRECTORY/sqlcl/bin/sql" ]]; then
  SQLCL_ZIP="$(mktemp)"
  curl --fail --location --output "$SQLCL_ZIP" \
    'https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-latest.zip'
  unzip -q "$SQLCL_ZIP" -d "$SQLCL_DIRECTORY"
  rm -f "$SQLCL_ZIP"
fi

WALLET_ZIP="$WALLET_DIRECTORY/Wallet_${ADBS_NAME}.zip"
az oracle-database autonomous-database generate-wallet \
  --resource-group "$RESOURCE_GROUP" \
  --autonomousdatabasename "$ADBS_NAME" \
  --generate-type Single \
  --is-regional false \
  --password "$WALLET_PASSWORD" \
  --file "$WALLET_ZIP"
unzip -o -q "$WALLET_ZIP" -d "$WALLET_DIRECTORY"

TNS_ALIAS="$(awk -F= -v name="${ADBS_NAME}_high" \
  'tolower($1) ~ "^[[:space:]]*" tolower(name) "[[:space:]]*$" {gsub(/[[:space:]]/, "", $1); print $1; exit}' \
  "$WALLET_DIRECTORY/tnsnames.ora")"
[[ -n "$TNS_ALIAS" ]] || {
  echo "Unable to find the ${ADBS_NAME}_high service alias in the wallet." >&2
  exit 1
}
AZURE_STORAGE_ACCOUNT_KEY="$(az storage account keys list \
  --resource-group "$RESOURCE_GROUP" \
  --account-name "$STORAGE_ACCOUNT" \
  --query '[0].value' --output tsv)"
[[ -n "$AZURE_STORAGE_ACCOUNT_KEY" ]] || { echo "No storage access key was returned." >&2; exit 1; }

# SQLcl uses the wallet ZIP to configure its JDBC connection. Credentials are
# passed on stdin, not as operating-system command-line arguments or a saved file.
"$SQLCL_DIRECTORY/sqlcl/bin/sql" -S -L -nohistory /nolog <<SQLCL_INPUT
whenever oserror exit failure rollback
whenever sqlerror exit failure rollback
set echo off verify off
set cloudconfig "$WALLET_ZIP"
connect ADMIN/"${ADMIN_PASSWORD}"@${TNS_ALIAS}
@"${SCRIPT_DIRECTORY}/provision-lake-demo.sql" "${LAKE_DEMO_PASSWORD}" "${STORAGE_ACCOUNT}.blob.core.windows.net" "${STORAGE_ACCOUNT}" "${AZURE_STORAGE_ACCOUNT_KEY}" "${CONTAINER}" "${TNS_ALIAS}"
SQLCL_INPUT

echo 'LAKE_DEMO is ready. Keep its password for the shared labs.'
