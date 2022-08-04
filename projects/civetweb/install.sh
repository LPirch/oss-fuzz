#!/bin/bash -eu
export LDFLAGS="${CFLAGS}"
targets="$@"
make clean
make -j$(nproc) $targets