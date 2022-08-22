#!/bin/bash -eux
./autogen.sh
./configure CFLAGS="$(gen_cflags)"
