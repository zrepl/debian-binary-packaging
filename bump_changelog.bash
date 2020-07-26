#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

VERSION="$1"
DATE="$(date -R)"
MAIL="me@cschwarz.com"

git checkout -- debian/changelog

cat > debian/upd_changelog <<EOF
zrepl ($VERSION) unstable; urgency=medium

 -- zrepl CI $MAIL $DATE

EOF

cat debian/changelog >> debian/upd_changelog
mv debian/upd_changelog debian/changelog