#!/usr/bin/env bash
# Import the public MovieStream sample data into this lab's private Azure container.
set -euo pipefail
[[ $# -eq 3 ]] || { echo "Usage: bash import-sample-data.sh RESOURCE_GROUP STORAGE_ACCOUNT CONTAINER" >&2; exit 1; }
RESOURCE_GROUP="$1"
STORAGE_ACCOUNT="$2"
CONTAINER="$3"
OCI_BUCKET_URL="https://objectstorage.us-ashburn-1.oraclecloud.com/n/c4u04/b/moviestream_landing/o"

command -v curl >/dev/null || { echo "curl is required." >&2; exit 1; }
command -v jq >/dev/null || { echo "jq is required." >&2; exit 1; }

TEMP_DIRECTORY="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIRECTORY"; unset STORAGE_KEY' EXIT

STORAGE_KEY=$(az storage account keys list --resource-group "$RESOURCE_GROUP" --account-name "$STORAGE_ACCOUNT" --query '[0].value' --output tsv)

az storage container create --account-name "$STORAGE_ACCOUNT" --account-key "$STORAGE_KEY" --name "$CONTAINER" --public-access off --output table

copy_object() {
  local source_object="$1"
  local destination_blob="$2"
  local local_file="$TEMP_DIRECTORY/$(basename "$source_object")"


  curl --fail --location --silent --show-error \
    "$OCI_BUCKET_URL/$source_object" \
    --output "$local_file"

  az storage blob upload \
    --account-name "$STORAGE_ACCOUNT" \
    --account-key "$STORAGE_KEY" \
    --container-name "$CONTAINER" \
    --name "$destination_blob" \
    --file "$local_file" \
    --overwrite true \
    --output none
}

# These destination names match the data/ paths used by the lab SQL scripts.
copy_object "customer/customer.csv" "data/customer.csv"
copy_object "customer_segment/customer_segment.csv" "data/customer_segment.csv"
copy_object "customer_extension/customer-extension.csv" "data/customer-extension.csv"
copy_object "genre/genre.csv" "data/genre.csv"
copy_object "movie/movies.json" "data/movies.json"

# List every object under the public custsales/ prefix and retain the directory
# hierarchy under data/custsales/ in Azure Blob Storage.
START_AFTER=""
CUSTSALES_COUNT=0
while :; do
  OBJECT_LIST="$(curl --fail --silent --show-error --get \
    --data-urlencode "prefix=custsales/" \
    --data-urlencode "start=$START_AFTER" \
    --data-urlencode "limit=1000" \
    "$OCI_BUCKET_URL")"

  mapfile -t CUSTSALES_OBJECTS < <(jq -r '.objects[]? | .name | select(endswith("/") | not)' <<<"$OBJECT_LIST")
  for source_object in "${CUSTSALES_OBJECTS[@]}"; do
    copy_object "$source_object" "data/$source_object"
    CUSTSALES_COUNT=$((CUSTSALES_COUNT + 1))
  done

  START_AFTER="$(jq -r '.nextStartWith // empty' <<<"$OBJECT_LIST")"
  [[ -n "$START_AFTER" ]] || break
done

[[ "$CUSTSALES_COUNT" -gt 0 ]] || { echo "No custsales objects were imported. Stop and check the public data source." >&2; exit 1; }

az storage blob list \
  --account-name "$STORAGE_ACCOUNT" \
  --account-key "$STORAGE_KEY" \
  --container-name "$CONTAINER" \
  --query "[].name" \
  --output table


