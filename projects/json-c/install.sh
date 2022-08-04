#!/bin/bash -eu
targets="$@"
if [ -f autogen.sh ]; then
  ./autogen.sh || ./autogen.sh
  ./configure CFLAGS="$CFLAGS"    
else
  mkdir build && cd build
  cmake ..
fi
make clean
make -j$(nproc) $targets