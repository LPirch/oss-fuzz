#!/bin/bash -eu
targets="$@"
svn co http://svn.apache.org/repos/asf/apr/apr/trunk srclib/apr
./buildconf
./configure CFLAGS="$CFLAGS" --with-included-apr

make clean
if [ -z "$targets" ]; then
    make -j$(nproc) || make -j$(nproc)  # parallel build may fail at first
else
    make $targets
fi