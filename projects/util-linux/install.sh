#!/bin/bash -eu
set -ex
targets="$@"

export LC_CTYPE=C.UTF-8

./autogen.sh
./configure --disable-all-programs --enable-libuuid --enable-libfdisk --enable-last --enable-libmount --enable-libblkid CFLAGS="$CFLAGS"
make clean
make -j$(nproc) $targets