#!/bin/bash -e

set -ex

flags="-O1 -fno-omit-frame-pointer -gline-tables-only"

export CFLAGS=${CFLAGS:-$flags}
export CXX=${CXX:-clang++}
export CXXFLAGS=${CXXFLAGS:-$flags}

export OUT=${OUT:-$(pwd)/out}
mkdir -p $OUT

if [ -f meson.build ]; then
    meson setup -Dprefix=/usr build -Dman=false
    meson compile -C build
else
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
fi