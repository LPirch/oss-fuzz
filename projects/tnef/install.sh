#!/bin/bash -eu
set -ex

autoreconf
./configure
make -j$(nproc)