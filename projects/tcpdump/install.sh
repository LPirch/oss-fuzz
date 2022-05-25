#!/bin/bash -eu

./configure CFLAGS="$CFLAGS"
make -j$(nproc)
