#!/bin/bash -eu
targets="$@"
make clean
clean_ast_files $OUT
cflags="$(gen_cflags) -no-integrated-as -fno-zero-initialized-in-bss"

set +e
build_logfile="${WORK}/logs/build.log"
if [ -f $build_logfile ]; then rm $build_logfile; fi
make -k -j$(nproc) CC=clang EXTRA_CFLAGS="$cflags" $targets >> $build_logfile 2>&1
set -e
