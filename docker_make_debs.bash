#!/bin/bash
set -eux

cd "$(dirname "${BASH_SOURCE[0]}")"

docker build -t zrepl_debian_pkg .

for arch in amd64 arm64 armhf i386; do
docker run --rm -i \
    -v "$PWD:/src" \
    -w "/src" \
    -e ZREPL_DEBIAN_BUILD_NOVERIFY_GPG \
    zrepl_debian_pkg bash /src/ondebian_make_debs.bash "$arch"
done

