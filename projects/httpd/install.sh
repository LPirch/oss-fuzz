#!/bin/bash -eu

svn co http://svn.apache.org/repos/asf/apr/apr/trunk srclib/apr
./buildconf
./configure CFLAGS="$CFLAGS" --with-included-apr
make -j$(nproc) || make -j$(nproc)  # parallel build may fail at first