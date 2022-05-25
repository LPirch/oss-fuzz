#!/bin/bash -eu

export LDFLAGS="${CFLAGS}"
./configure --enable-ctrls
make -j$(nproc)
