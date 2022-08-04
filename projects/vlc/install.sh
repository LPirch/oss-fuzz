#!/bin/bash -eu
targets="$@"

./bootstrap
./configure --disable-qt --disable-mad --disable-qt4 --disable-skins2 CFLAGS="$CFLAGS"
make clean
make -j$(nproc) LDFLAGS="-pthread" $targets
