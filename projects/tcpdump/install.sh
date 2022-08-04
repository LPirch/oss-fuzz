#!/bin/bash -eu
targets="$@"

./configure CFLAGS="$CFLAGS"
make clean
make -j$(nproc) $targets