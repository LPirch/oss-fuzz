#!/bin/bash -eu
set -ex
targets="$@"

autoreconf
./configure CFLAGS="$CFLAGS"
make clean
make -j$(nproc) $targets