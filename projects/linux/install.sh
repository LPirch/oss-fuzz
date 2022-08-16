#!/bin/bash -eu
targets="$@"
make clean
clean_ast_files $OUT

set +e
build_logfile="${WORK}/logs/build.log"
make -k -j$(nproc) CC=clang EXTRA_CFLAGS="$CFLAGS -no-integrated-as -f-fno-zero-initialized-in-bss" $targets >> $build_logfile 2>&1
if grep "No rule to make target" $build_logfile >/dev/null ; then
    make -k -j$(nproc) CC=clang EXTRA_CFLAGS="$CFLAGS -no-integrated-as -f-fno-zero-initialized-in-bss"  >> $build_logfile 2>&1
fi
set -e
