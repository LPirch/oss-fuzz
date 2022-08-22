#!/bin/bash -eux

autoreconf -ivf
./configure CFLAGS="$(gen_cflags)"
