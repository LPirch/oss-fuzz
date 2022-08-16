#!/bin/bash -e

set -ex
targets="$@"
flags="-O1 -fno-omit-frame-pointer -gline-tables-only"

export CFLAGS=${CFLAGS:-$flags}
export CXX=${CXX:-clang++}
export CXXFLAGS=${CXXFLAGS:-$flags}
export CC_LD=gold

clean_ast_files $OUT
if [ -f meson.build ]; then
    meson setup -Dprefix=/usr build -Dman=false
    meson compile -C build --clean $targets # TODO: similar mechanism for meson builds
else
    ./autogen.sh
    ./configure CFLAGS="$CFLAGS"
    make clean

    set +e
    error_file="${SRC}/errors.log"
    make -k -j$(nproc) $targets 2>$error_file
    if grep "No rule to make target" $error_file >/dev/null ; then
        make -k -j$(nproc)
    fi
    if [ -f $error_file ]; then 
        rm $error_file
    fi
    set -e
fi