#!/usr/bin/env bash
# Lab-only shared-password input adapter. No password is stored in this file.
set +x
set -euo pipefail
[[ $(id -un) == oracle ]] || { echo 'Run as oracle.' >&2; exit 1; }
case "${1:-}" in
  --eval) mode=(-eval) ;;
  --migrate) mode=(-pauseafter ZDM_MONITOR_GG_LAG) ;;
  *) echo 'Usage: bash zdm-submit-once.sh --eval|--migrate' >&2; exit 2 ;;
esac
source "$HOME/env/source19c.env"
source /etc/profile.d/zdm26.sh
source /data/oracle/lab/config/lab-env.sh
export ORACLE_SID ZDM_HOME ZDM_RESPONSE_FILE
exec python3 "$HOME/zdm-submit-once.py" "$1"
