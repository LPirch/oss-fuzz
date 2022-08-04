#!/bin/bash -eu
targets="$@"

./configure CFLAGS="$CFLAGS"
make -j$(nproc) $targets