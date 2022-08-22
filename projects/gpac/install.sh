#!/bin/bash -eu
targets="$@"
clean_ast_files $OUT
make clean

set +e
build_logfile="${WORK}/logs/build.log"
if [ -f $build_logfile ]; then rm $build_logfile; fi
make -k -j$(nproc) $targets >> $build_logfile 2>&1
