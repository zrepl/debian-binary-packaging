#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

commit="$1"
goversion="$2"

[ -n "$commit" -a -n "$goversion" ] || ( echo "arguments must not be empty: commit=$commit goversion=$goversion"; exit 1 )

rm -rf release

aws="aws --endpoint-url https://minio.cschwarz.com --no-sign-request"


path="s3://zrepl-ci-artifacts/$commit/build-$goversion/release"
$aws s3 sync --delete "$path" ./release
