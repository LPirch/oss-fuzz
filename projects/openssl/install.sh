#!/bin/bash -eu
targets="$@"

./config
sed -i "s#^CFLAG=#CFLAG = $CFLAGS #" Makefile
make clean
clean_ast_files $OUT

set +e
error_file="${SRC}/errors.log"
# parallel build fails in older versions but can recover if started again
make -k -j$(nproc) $targets 2>$error_file || make -k -j$(nproc) $targets 2>$error_file
if grep "No rule to make target" $error_file >/dev/null ; then
    make -k -j$(nproc) || make -k -j$(nproc)
fi
if [ -f $error_file ]; then 
    rm $error_file
fi
set -e


