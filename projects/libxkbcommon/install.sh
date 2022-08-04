#!/bin/bash -eu
targets="$@"

if [ -f autogen.sh ]; then
  sh autogen.sh --disable-x11
  ./configure --disable-x11 CFLAGS="$CFLAGS"
  make clean
  make -j$(nproc) targets
else
  meson setup build
  ninja -C build $targets
fi