#!/bin/bash -eu

if [ -f autogen.sh ]; then
  sh autogen.sh --disable-x11
  ./configure --disable-x11 CFLAGS="$CFLAGS"
  make -j$(nproc)
else
  meson setup build
  ninja -C build
fi