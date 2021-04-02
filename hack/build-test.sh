#!/usr/bin/env bash

set -o errexit
set -o nounset

for gomodule in $(find . | grep "go\.mod" | awk '{gsub(/\/go.mod/,""); print $0}' | grep -v "./test")
do
  echo
  echo --- Building $gomodule ---
  echo
  pushd $gomodule
  

  tags="$(grep -I  -r '// +build' . | cut -f3 -d' ' | sort | uniq | grep -v '^!' | tr '\n' ' ')"
  
  echo "Building with tags: ${tags}"
  go test -vet=off -tags "${tags}" -run=^$ ./... | grep -v "no test" || true
  
  popd
done
