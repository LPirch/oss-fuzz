#!/bin/bash -eu
targets="$@"

make clean
make -j$(nproc) $targets
