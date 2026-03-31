#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

status=0

check_dir() {
  local dir="$1"
  if [[ ! -d "$dir" ]]; then
    echo "ERROR: missing directory '$dir'"
    status=1
  fi
}

check_file() {
  local file="$1"

  if ! jq empty "$file" >/dev/null 2>&1; then
    echo "ERROR: invalid JSON in '$file'"
    status=1
    return
  fi

  if [[ "$(jq -r 'has("dashboard")' "$file")" == "true" ]]; then
    echo "ERROR: '$file' is wrapped as an API export ({\"dashboard\": ...}) and is not ready for file provisioning"
    status=1
  fi

  if [[ "$(jq -r 'has("title") and has("panels")' "$file")" != "true" ]]; then
    echo "ERROR: '$file' is missing required top-level dashboard keys"
    status=1
  fi

  if jq -e '
    .. | objects
    | select(has("datasource"))
    | .datasource
    | type == "object" and (.uid // "") == "PROM_UID_HERE"
  ' "$file" >/dev/null; then
    echo "WARN: '$file' still contains datasource placeholder 'PROM_UID_HERE'"
  fi

  if [[ "$(jq -r '(.uid // "")' "$file")" == "" ]]; then
    echo "WARN: '$file' has no dashboard uid; Grafana will generate one on import"
  fi
}

echo "Checking dashboard directories..."
check_dir "application"
check_dir "infrastructure"
check_dir "business"

echo "Checking dashboard JSON files..."
while IFS= read -r file; do
  check_file "$file"
done < <(find application infrastructure business -type f -name '*.json' | sort)

echo "Checking provisioning file..."
if [[ ! -f provisioning/dashboards.yml ]]; then
  echo "ERROR: provisioning/dashboards.yml not found"
  status=1
else
  while IFS= read -r dir; do
    check_dir "$dir"
  done < <(awk '/path:/ {print $2}' provisioning/dashboards.yml | sed -E 's#.*/dashboards/##' || true)
fi

if [[ "$status" -eq 0 ]]; then
  echo "OK: dashboard validation passed"
else
  echo "FAILED: dashboard validation found issues"
fi

exit "$status"
