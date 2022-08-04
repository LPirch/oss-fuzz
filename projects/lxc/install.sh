#!/bin/bash -e

set -ex
targets="$@"
flags="-O1 -fno-omit-frame-pointer -gline-tables-only"

export CFLAGS=${CFLAGS:-$flags}
export CXX=${CXX:-clang++}
export CXXFLAGS=${CXXFLAGS:-$flags}
export CC_LD=gold

if [ -f meson.build ]; then
    meson setup -Dprefix=/usr build -Dman=false
    meson compile -C build --clean $targets
else
    ./autogen.sh
    ./configure CFLAGS="$CFLAGS"
    make clean
    make -j$(nproc) $targets
fi