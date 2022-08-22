#!/bin/bash -eux
export LC_CTYPE=C.UTF-8
export CFLAGS="$(gen_cflags)"
./autogen.sh
./configure --disable-all-programs --enable-libuuid --enable-libfdisk \
            --enable-last --enable-libmount --enable-libblkid CFLAGS="$CFLAGS"
make clean
