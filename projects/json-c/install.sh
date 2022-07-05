#!/bin/bash -eu

if [ -f autogen.sh ]; then
  sh autogen.sh
  ./configure CFLAGS="$CFLAGS"
  make -j$(nproc)
else
  mkdir build && cd build
  cmake ..
  make -j$(nproc)
fi