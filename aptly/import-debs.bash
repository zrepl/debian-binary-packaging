#!/bin/bash
set -eo
set -x

cd "$(dirname "${BASH_SOURCE[0]}")"

shopt -s expand_aliases # required for env.bash
source env.bash

REPONAME=unstable
FLAGS="-architectures=amd64,arm64,armhf,i386 -gpg-key E101418FD3D6FBCB9D65A62D708699FC5F2EBF16"
DISTS=()
DISTS+=("-distribution=focal   $REPONAME :ubuntu")
DISTS+=("-distribution=eoan    $REPONAME :ubuntu")
DISTS+=("-distribution=disco   $REPONAME :ubuntu")
DISTS+=("-distribution=bionic  $REPONAME :ubuntu")
DISTS+=("-distribution=buster  $REPONAME :debian")
DISTS+=("-distribution=stretch $REPONAME :debian")

if [ "y$ZREPL_APTLY_INIT_REPOS" != "y" ]; then
    aptly repo create unstable
    for dist in "${DISTS[@]}"; do
        aptly publish repo $FLAGS $dist
    done
fi

if stat -t ../debs/zrepl_*changes; then
    aptly repo include -accept-unsigned ../debs/zrepl_*changes
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
