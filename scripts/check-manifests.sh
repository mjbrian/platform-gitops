#!/usr/bin/env bash
# Checks every Kubernetes file and Helm chart in this repo.
set -euo pipefail
shopt -s nullglob

CRDS='https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json'
CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/kubeconform"
RENDERED="$(mktemp)"
trap 'rm -f "$RENDERED"' EXIT
mkdir -p "$CACHE"

check() {
  kubeconform -strict -summary -cache "$CACHE" \
    -schema-location default -schema-location "$CRDS" "$@"
}

for dir in bootstrap apps; do
  if [[ -d "$dir" ]]; then check "$dir"; fi
done

for chart in charts/*/; do
  helm lint --strict "$chart"
  helm template lab "$chart" > "$RENDERED"
  check "$RENDERED"
done
