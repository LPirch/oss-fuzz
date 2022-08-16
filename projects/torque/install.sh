#!/bin/bash -eu
set -ex
targets="$@"

if [ -f "./autogen.sh" ]; then
    # disable failing on warnings
    sed -i 's/-Werror/-Wno-error/g' configure.ac
    ./autogen.sh
fi

CONFIG_SCRIPT="configure"
if [ ! -f ./$CONFIG_SCRIPT ]; then
  CONFIG_SCRIPT="config"
fi
./$CONFIG_SCRIPT CFLAGS="$CFLAGS" 
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