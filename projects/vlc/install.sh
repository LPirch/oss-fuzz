#!/bin/bash -eu

./bootstrap
./configure --disable-ogg --disable-oggspots --disable-libxml2 --disable-lua \
            --disable-shared \
            --enable-static \
            --enable-vlc=no \
            --disable-avcodec \
            --disable-swscale \
            --disable-a52 \
            --disable-xcb \
            --disable-alsa \
            --with-libfuzzer
make V=1 -j$(nproc)
