#!/bin/bash -eu

./bootstrap
./configure --disable-qt
make V=1 -j$(nproc)
