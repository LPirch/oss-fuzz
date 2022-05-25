#!/bin/bash -e

set -ex

flags="-O1 -fno-omit-frame-pointer -gline-tables-only"

export CFLAGS=${CFLAGS:-$flags}
export CXX=${CXX:-clang++}
export CXXFLAGS=${CXXFLAGS:-$flags}

export OUT=${OUT:-$(pwd)/out}
mkdir -p $OUT

./autogen.sh
./configure \
    --disable-tools \
    --disable-commands \
    --disable-apparmor \
    --disable-openssl \
    --disable-selinux \
    --disable-seccomp \
    --disable-capabilities \
    --disable-no-undefined
make -j$(nproc)
