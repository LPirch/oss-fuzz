#!/bin/bash -eu

targets="$@"
clean_ast_files $OUT

set +e
build_logfile="${WORK}/logs/build.log"
if [ -f $build_logfile ]; then rm $build_logfile; fi

if [ -z "${targets[@]}" ]; then
    cmake --build . --clean-first -- -k >> $build_logfile 2>&1
else
    for t in ${targets[@]}; do
        d=$(dirname $t)
        stem=$(basename $t)
        pushd $d
        cmake --build . --clean-first --target $stem >> $build_logfile 2>&1
        popd
    done
fi
set -e
