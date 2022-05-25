#!/bin/bash -eu

apt install -y libbz2-dev
./autogen.sh
./configure --without-pcre --enable-static
make -j$(nproc)
