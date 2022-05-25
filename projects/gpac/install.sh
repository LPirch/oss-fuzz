#!/bin/bash -eu

./configure --static-build --extra-cflags="${CFLAGS}" --extra-ldflags="${CFLAGS}"
make -j$(nproc)
