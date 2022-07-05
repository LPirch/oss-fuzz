#!/bin/bash -eu

# add subdir-objects option to automake (builds may fail otherwise)
sed -ri 's/AM_INIT_AUTOMAKE\(\[/AM_INIT_AUTOMAKE\(\[subdir-objects /g' configure.ac

# may need two trials (somehow works the second time)
sh autogen.sh || sh autogen.sh
./configure || ./configure
make -j$(nproc) CFLAGS="$(egrep '^CFLAGS ='  Makefile | sed -e 's/CFLAGS = //') -c" # only compile, don't link