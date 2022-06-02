#!/bin/bash -eu

sh autogen.sh --disable-x11
./configure --disable-x11 CFLAGS="$CFLAGS"
make -j$(nproc)
