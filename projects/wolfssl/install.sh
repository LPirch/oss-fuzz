#!/bin/bash -eu
sh autogen.sh
./configure CFLAGS="$CFLAGS" --disable-x11
make -j$(nproc) install