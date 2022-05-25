#!/bin/bash -eu
export LDFLAGS="${CFLAGS}"

make -j$(nproc)