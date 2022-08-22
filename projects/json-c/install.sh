#!/bin/bash -eux
targets="$@"
make clean
clean_ast_files $OUT

set +e
build_logfile="${WORK}/logs/build.log"
if [ -f $build_logfile ]; then rm $build_logfile; fi
if [ -f autogen.sh ]; then
  make -k -j$(nproc) $targets >> $build_logfile 2>&1
else
  cmake --build . --clean-first --target $targets >> $build_logfile 2>&1
fi
set -e