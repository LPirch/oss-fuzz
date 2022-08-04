#!/bin/bash -eu
targets="$@"

# second command for older versions
./autogen.sh || autoreconf -vfi
./configure CFLAGS="$CFLAGS"
make clean
make -j$(nproc) $targets
