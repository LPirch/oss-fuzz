#!/bin/bash -eux

./autogen.sh 
./configure --without-pcre --enable-static CFLAGS="$(gen_cflags)"
