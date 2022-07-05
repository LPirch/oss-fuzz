#!/bin/bash -eu

autoreconf -fi
./configure --with-openssl
make -j$(nproc)
