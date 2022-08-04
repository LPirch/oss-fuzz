#!/bin/bash -eu
targets="$@"

# Compile the fuzzer.
./autogen.sh
./configure CFLAGS="$CFLAGS"
make clean
make -j$(nproc) $targets
