#!/bin/bash -eux

targets="$@"
cflags="$(gen_cflags)"

export CFLAGS=${CFLAGS:-$cflags}
export CC_LD=gold

clean_ast_files $OUT
set +e
build_logfile="${WORK}/logs/build.log"
if [ -f $build_logfile ]; then rm $build_logfile; fi
if [ -f meson.build ]; then
    CC=clang CFLAGS="${CFLAGS}" meson compile -C build --clean $targets >> $build_logfile 2>&1
else
    make clean
    make -k -j$(nproc) $targets >> $build_logfile 2>&1
fi
set -e