#!/bin/bash -eu

sh autogen.sh
./configure CFLAGS="$CFLAGS"
make