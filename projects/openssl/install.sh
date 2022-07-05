#!/bin/bash -eu

./config CFLAGS="$CFLAGS"
make install # parallel build fails (at least in older versions)
