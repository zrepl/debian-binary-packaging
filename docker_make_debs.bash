#!/bin/bash
set -eux

cd "$(dirname "${BASH_SOURCE[0]}")"

docker build -t zrepl_debian_pkg .

for arch in amd64 arm64; do
docker run --rm -it \
    -v "$PWD:/src" \
    -u $(id -u):$(id -g) \
    -w "/src" \
    zrepl_debian_pkg bash /src/ondebian_make_debs.bash "$arch"
done

