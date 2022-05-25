#!/bin/bash -eu
set -ex

./configure CFLAGS="$CFLAGS" 
make -j$(nproc)