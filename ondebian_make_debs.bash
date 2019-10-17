#!/bin/bash
set -euo
set -x

ARCH="$1"

dpkg-buildpackage -b --no-sign --host-arch "$ARCH"
cp -v ../*zrepl* debs/

