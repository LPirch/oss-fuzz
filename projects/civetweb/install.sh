#!/bin/bash -eu
export LDFLAGS="${CFLAGS}"
targets="$@"
make clean
clean_ast_files $OUT

set +e
error_file="${OUT}/build_errors.log"
make -k -j$(nproc) $targets 2>$error_file
if grep "No rule to make target" $error_file 1>/dev/null 2>&1 ; then
    rm $error_file
    make -k -j$(nproc) 2>$error_file
fi
set -e