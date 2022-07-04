#!/bin/bash -eu

autoreconf -fi
./configure --without-ssl
make -j$(nproc)
