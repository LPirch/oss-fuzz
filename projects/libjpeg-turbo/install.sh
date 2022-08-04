#!/bin/bash -e
targets="$@"

mkdir build
cd build
cmake -G"Unix Makefiles" ..
make clean
make -j$(nproc) $targets
