#!/bin/bash -eu
set -ex

export LC_CTYPE=C.UTF-8

export CC=${CC:-clang}
export CXX=${CXX:-clang++}

# flags="-O1 -fno-omit-frame-pointer -gline-tables-only"

#export CFLAGS=${CFLAGS:-$flags}
#export CXXFLAGS=${CXXFLAGS:-$flags}

export OUT=${OUT:-$(pwd)/out}
mkdir -p $OUT

./autogen.sh
./configure --disable-all-programs --enable-libuuid --enable-libfdisk --enable-last --enable-libmount --enable-libblkid
make -j$(nproc)