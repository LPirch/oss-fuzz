#!/bin/bash -eu
targets="$@"

# add subdir-objects option to automake (builds may fail otherwise)
sed -ri 's/AM_INIT_AUTOMAKE\(\[/AM_INIT_AUTOMAKE\(\[subdir-objects /g' configure.ac

# may need two trials (somehow works the second time)
sh autogen.sh || sh autogen.sh
./configure CFLAGS="$CFLAGS" || ./configure CFLAGS="$CFLAGS"
make clean
clean_ast_files $OUT

set +e
error_file="${SRC}/errors.log"
make -k -j$(nproc) $targets 2>$error_file
if grep "No rule to make target" $error_file >/dev/null ; then
    make -k -j$(nproc)
fi
if [ -f $error_file ]; then 
    rm $error_file
fi
set -e