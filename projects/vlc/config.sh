#!/bin/bash -eu

cflags="$(gen_cflags)"
./bootstrap
./configure CFLAGS="$cflags" \
    --enable-dvbpsi \
    --enable-gme \
    --enable-ogg \
    --enable-shout \
    --enable-matroska \
    --enable-mod \
    --enable-mpc \
    --disable-qt \
    --disable-mad \
    --disable-qt4 \
    --disable-skins2
