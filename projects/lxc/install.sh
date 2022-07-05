#!/bin/bash -e

set -ex

flags="-O1 -fno-omit-frame-pointer -gline-tables-only"

export CFLAGS=${CFLAGS:-$flags}
export CFLAGS=${CFLAGS//-DFUZZING_BUILD_MODE_UNSAFE_FOR_PRODUCTION/}  # remove fuzzing flags
export CXX=${CXX:-clang++}
export CXXFLAGS=${CXXFLAGS:-$flags}
export CC_LD=gold

export OUT=${OUT:-$(pwd)/out}
mkdir -p $OUT

if [ -f meson.build ]; then
    meson setup -Dprefix=/usr build -Dman=false
    meson compile -C build
else
    ./autogen.sh
    ./configure
    make -j$(nproc)
fi