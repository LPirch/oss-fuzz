#!/bin/bash -eu

./bootstrap
./configure --disable-qt --disable-mad --disable-qt4 --disable-skins2
make -j$(nproc) LDFLAGS="-pthread"
