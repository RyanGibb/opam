#!/bin/sh
set -eux

#git config --global --add safe.directory /github/workspace

# Workdir is /github/workpaces
#cd /github/workspace

### LOCAL TESTING
git clone https://github.com/RyanGibb/opam --single-branch --branch nixos-depexts-ci --depth 1 local-opam
cd local-opam

/usr/bin/opam install . --deps
eval $(/usr/bin/opam env)
./configure
make
./opam var --global os-family=nixos
./opam var --global os-distribution=nixos
./opam repo add test git+https://github.com/RyanGibb/opam-repository.git --set-default --all
./opam repo remove default --all
./opam update
./opam repo list
./opam switch create confs --empty

ERRORS=""
test_depexts () {
  for pkg in $@ ; do
    ./opam install $pkg || ERRORS="$ERRORS $pkg"
  done
}

test_depexts  conf-gmp.4 conf-which.1 conf-autoconf.0.1 conf-automake.1 conf-dpkg.1

if [ -z "$ERRORS" ]; then
  exit 0
else
  echo "ERROR on packages$ERRORS"
  exit 1
fi
./opam update --depexts || ERRORS="$ERRORS opam-update-depexts"
