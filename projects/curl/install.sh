#!/bin/bash -eu
targets="$@"
sed -i 's/^AC_CONFIG_MACRO_DIR/#AC_CONFIG_MACRO_DIR/g' configure.ac
autoreconf -fi
./configure --with-openssl
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