#!/bin/bash -eux

autoreconf -i -v -f
./configure CFLAGS="$(gen_cflags)"
