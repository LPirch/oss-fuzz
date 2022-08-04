#!/bin/bash -eu
targets="$@"
./autogen.sh
./configure --without-pcre --enable-static CFLAGS="$CFLAGS"
make clean
make -j$(nproc) $targets
