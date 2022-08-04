#!/bin/bash -eu
targets="$@"
./configure --static-build --extra-cflags="${CFLAGS}" --extra-ldflags="${CFLAGS}"
make clean
make -j$(nproc) $targets
