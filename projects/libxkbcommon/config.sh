#!/bin/bash -eu
if [ -f autogen.sh ]; then
  sh autogen.sh --disable-x11
  ./configure --disable-x11 CFLAGS="$(gen_cflags)"
else
  CC=clang CFLAGS="$(gen_cflags)" meson setup build
fi