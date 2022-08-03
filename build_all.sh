#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: build_all.sh <CSV_FILE>"
    exit 1
fi

CSV=$1
n_rows=$(wc -l $CSV | cut -d ' ' -f1)
let N_TOTAL=n_rows-1
i=1
BASE_DIR=$(dirname $(realpath $0))
{
    read  # skip header
    while IFS=, read -r project commit prev_commit url types cves
    do
        for c in $commit $prev_commit
        do
            outzip="${BASE_DIR}/build/out/${project}/${c}/${project}.zip"
            if [ -f "$outzip" ]; then
                echo "[$i/$N_TOTAL] skipping ${project}@${c}"
            else
                echo "[$i/$N_TOTAL] extracting ${project}@${c}"
                python3 infra/helper.py build_fuzzers $project --commit $c --graph --zip --noinst --clean --passuser --cpus 60
            fi
        done
        let i+=1
    done
} < $CSV
