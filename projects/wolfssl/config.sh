#!/bin/bash -eux

sh autogen.sh
./configure CFLAGS="$(gen_cflags)" --disable-x11
