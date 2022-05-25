#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: build_all.sh <CSV_FILE>"
    exit 1
fi

CSV=$1
BASE_DIR=$(dirname $(realpath $0))
{
    read  # skip header
    while IFS=, read -r project url commit typ
    do
        outzip="${BASE_DIR}/build/out/${project}/${commit}/${project}.zip"
        if [ -f "$outzip" ]; then
            echo "skipping ${project}@${commit}"
        else
            python infra/helper.py build_fuzzers $project --commit $commit --graph --zip --noinst --clean
        fi
    done
} < $CSV