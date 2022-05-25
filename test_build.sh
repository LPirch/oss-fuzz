#!/bin/bash

if [ "$#" -lt 2 ]; then
    echo "Usage: test_build.sh <DS_CSV> <OUT_FILE>"
    exit 1
fi
DS_CSV=$1
OUT_FILE=$2

if [ -f "$OUT_FILE" ]; then
    rm "$OUT_FILE"
fi

{
    while IFS=, read -r project commit url typ cve
    do 
        echo "[-] Building $project@$commit"
        # echo "$project" >> projects.list
        python infra/helper.py build_fuzzers $project --commit $commit --graph --zip --noinst --clean --nprocs 6
        exit_code=$?
        echo "$project,$commit,$exit_code" >> $OUT_FILE
    done
} < <(cat $DS_CSV | tail -n +2 | sort -u -t, -k1,1)
