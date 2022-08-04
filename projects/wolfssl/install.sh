#!/bin/bash -eu
targets="$@"
sh autogen.sh
./configure CFLAGS="$CFLAGS" --disable-x11
make clean
make -j$(nproc) $targets
