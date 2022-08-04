#!/bin/bash -eu
targets="$@"

export LDFLAGS="${CFLAGS}"
./configure --enable-ctrls CFLAGS="$CFLAGS"
make clean
make -j$(nproc) $targets
