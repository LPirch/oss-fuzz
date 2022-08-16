#!/bin/bash -eu
targets="$@"
svn co http://svn.apache.org/repos/asf/apr/apr/trunk srclib/apr
./buildconf
./configure CFLAGS="$CFLAGS" --with-included-apr

make clean
clean_ast_files $OUT

set +e
error_file="${SRC}/errors.log"
make -k -j$(nproc) $targets 2>$error_file || make -k -j$(nproc) $targets 2>$error_file
if grep "No rule to make target" $error_file >/dev/null ; then
    make -k -j$(nproc) 2>$error_file || make -k -j$(nproc) 2>$error_file
fi
if [ -f $error_file ]; then 
    rm $error_file
fi
set -e
