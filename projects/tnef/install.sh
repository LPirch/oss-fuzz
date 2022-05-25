#!/bin/bash -eu
set -ex

autoreconf
./configure CFLAGS="$CFLAGS" 
make -j$(nproc)