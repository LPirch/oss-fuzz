#!/bin/bash -eux

# add subdir-objects option to automake (builds may fail otherwise)
sed -ri 's/AM_INIT_AUTOMAKE\(\[/AM_INIT_AUTOMAKE\(\[subdir-objects /g' configure.ac

# may need two trials (somehow works the second time)
sh autogen.sh || sh autogen.sh
cflags="$(gen_cflags)"
./configure CFLAGS="$cflags" || ./configure CFLAGS="$cflags"
