#!/bin/bash
set -euo
set -x

ARCH="$1"

dpkg-buildpackage -b --no-sign --host-arch "$ARCH"
mkdir -p debs/
cp -v ../*zrepl* debs/

