#!/bin/bash -eu

targets="$@"
mkdir build && cd build
if [ -z $targets ]; then
    cmake ../
else
    cmake ../ --target $targets
fi