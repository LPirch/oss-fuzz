#!/bin/bash -eu
targets="$@"

# second command for older versions
./autogen.sh || autoreconf -vfi
./configure CFLAGS="$(gen_cflags)"
