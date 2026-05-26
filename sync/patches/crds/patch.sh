#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

repo_dir=$(git rev-parse --show-toplevel) ; readonly repo_dir
cd "${repo_dir}"

templates_path="./helm/envoy-gateway-crds/templates/crds"
mkdir -p "${templates_path}"
rm -f "${templates_path}"/*.yaml

set -x
for f in ./vendor/gateway-helm/charts/crds/crds/generated/*.yaml ; do
  cp "$f" "${templates_path}/"
done

cd "${templates_path}"
{ set +x; } 2>/dev/null

for f in *.yaml ; do
  set -x
  yq -i '.metadata.annotations += {"helm.sh/resource-policy":"keep"}' "$f"
  { set +x; } 2>/dev/null
done
