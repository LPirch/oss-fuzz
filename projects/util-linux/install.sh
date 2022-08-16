#!/bin/bash -eux
targets="$@"
CFLAGS="$(gen_cflags)"
make clean
clean_ast_files $OUT

set +e
build_logfile="${WORK}/logs/build.log"
make -k -j$(nproc) $targets >> $build_logfile 2>&1
if grep "No rule to make target" $build_logfile >/dev/null ; then
    make -k -j$(nproc) >> $build_logfile 2>&1
fi
set -e