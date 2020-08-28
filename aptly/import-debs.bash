#!/bin/bash
set -euo
set -x

cd "$(dirname "${BASH_SOURCE[0]}")"

shopt -s expand_aliases # required for env.bash
source env.bash

REPONAME=unstable
FLAGS_ARCHITECTURES="-architectures=amd64,arm64,armhf,i386"
FLAGS="$FLAGS_ARCHITECTURES -gpg-key E101418FD3D6FBCB9D65A62D708699FC5F2EBF16"
DISTS=()
DISTS+=("-distribution=focal   $REPONAME :ubuntu")
DISTS+=("-distribution=eoan    $REPONAME :ubuntu")
DISTS+=("-distribution=disco   $REPONAME :ubuntu")
DISTS+=("-distribution=bionic  $REPONAME :ubuntu")
DISTS+=("-distribution=buster  $REPONAME :debian")
DISTS+=("-distribution=stretch $REPONAME :debian")

if [ -v ZREPL_APTLY_INIT_REPOS ]; then
    aptly repo create unstable
    for dist in "${DISTS[@]}"; do
        aptly publish repo $FLAGS $dist
    done
fi
if [ -v ZREPL_APTLY_DROP_REPOS ]; then
    for dist in "${DISTS[@]}"; do
        dist="${dist#-distribution=}"
        dist="${dist/$REPONAME/}"
        aptly publish drop $dist
    done
    aptly repo drop unstable
fi

if stat -t ../debs/zrepl_*changes; then
    aptly repo include $FLAGS_ARCHITECTURES -accept-unsigned ../debs/zrepl_*changes
fi

for dist in "${DISTS[@]}"; do
    # extract params
    dist="${dist#-distribution=}"
    dist="${dist/$REPONAME/}"
    aptly publish update $FLAGS $dist
done

echo Now MANUALLY sync to server
echo ""
echo 	rsync --delete -v -aH root/ web.hetzner1.cschwarz.com:/var/www/zrepl.cschwarz.com/apt/aptlyroot
