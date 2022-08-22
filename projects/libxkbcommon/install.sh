#!/bin/bash -eu
targets="$@"

build_logfile="${WORK}/logs/build.log"
if [ -f $build_logfile ]; then rm $build_logfile; fi

if [ -f autogen.sh ]; then
  make clean
  clean_ast_files $OUT

  set +e
  make -k -j$(nproc) $targets >> $build_logfile 2>&1
  set -e
else
  ninja -C build --clean $targets >> $build_logfile 2>&1
fi