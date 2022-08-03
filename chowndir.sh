#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: chowndir.sh <DIR>"
    exit 1
fi

DIR=$1
user=$(id -u)
group=$(id -g)

docker run --rm -v $(realpath $DIR):/host ubuntu:focal chown -R $user:$group /host