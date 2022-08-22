#!/bin/bash -eux

if [ -f autogen.sh ]; then
  ./autogen.sh || ./autogen.sh
  ./configure CFLAGS="$(gen_cflags)"    
else
  cmake . -DCMAKE_C_FLAGS="$(gen_cflags)"
fi
