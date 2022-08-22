#!/bin/bash -eux
cflags="$(gen_cflags)"
if [ -f meson.build ]; then
    CC=clang CFLAGS="$cflags" meson setup build -Dman=false
else
    ./autogen.sh
    ./configure CFLAGS="$cflags"
fi