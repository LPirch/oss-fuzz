#!/bin/bash -eu

targets="$@"
mkdir build && cd build
clean_ast_files $OUT

set +e
error_file="${SRC}/errors.log"

if [ -z $targets ]; then
    cmake ../ --clean-first --build -- -k  2>$error_file
else
    cmake ../ --clean-first --target $targets --build -- -k  2>$error_file
    if grep "No rule to make target" $error_file >/dev/null ; then
        cmake ../ --clean-first --build -- -k  2>$error_file
    fi
fi
if [ -f $error_file ]; then 
    rm $error_file
fi
set -e