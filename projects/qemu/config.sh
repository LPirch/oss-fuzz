#!/bin/sh -eux

./configure --python=$(which python2.7) --cc=clang --extra-cflags="$(gen_cflags)"
