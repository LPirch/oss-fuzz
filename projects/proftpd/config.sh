#!/bin/bash -eux

./configure --enable-ctrls CFLAGS="$(gen_cflags)"
