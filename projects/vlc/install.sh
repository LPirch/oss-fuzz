#!/bin/bash -eu
targets="$@"

./bootstrap
./configure --disable-qt --disable-mad --disable-qt4 --disable-skins2 CFLAGS="$CFLAGS"

make clean
clean_ast_files $OUT

set +e
build_logfile="${WORK}/logs/build.log"
make -k -j$(nproc) LDFLAGS="-pthread" $targets >> $build_logfile 2>&1
if grep "No rule to make target" $build_logfile >/dev/null ; then
    make clean
    clean_ast_files $OUT
    make -k -j$(nproc) LDFLAGS="-pthread" >> $build_logfile 2>&1
fi
if [ -f $build_logfile ]; then 
    rm $error_file
fi
set -e