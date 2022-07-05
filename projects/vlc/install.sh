#!/bin/bash -eu

./bootstrap
./configure --disable-qt
make -j$(nproc)
