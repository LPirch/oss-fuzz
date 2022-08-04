#!/bin/sh -e
targets="$@"
mkdir build
cd build
../configure CFLAGS="$CFLAGS"
make -j$(nproc) $targets