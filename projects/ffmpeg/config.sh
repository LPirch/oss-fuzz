#!/bin/bash -eux

# remove Werror flags from configure
sed -ie '/check_cflags\s*-Werror=/d' configure || :
cflags="$(gen_cflags)"
./configure --cc=$CC --extra-cflags="$cflags" \
    --enable-gpl \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libopus \
    --enable-libtheora \
    --enable-libvorbis \
    --disable-libcdio \
    --enable-nonfree \
    --disable-doc \
    --disable-shared || \
    ./configure --cc=$CC  --extra-cflags="$cflags" # fall-back: default options