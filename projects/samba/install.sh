#!/bin/bash -eux
targets="$@"
clean_ast_files $OUT
make clean

set +e
build_logfile="${WORK}/logs/build.log"
make -k -j$(nproc) $targets >> $build_logfile 2>&1
set -e