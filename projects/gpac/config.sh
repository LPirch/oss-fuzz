#!/bin/bash -eux
cflags="$(gen_cflags)"
./configure --static-build --extra-cflags="${cflags}"
