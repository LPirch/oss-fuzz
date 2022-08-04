#!/bin/bash -eu
targets="$@"

# build project
./autogen.sh
./configure PCRE2_LIBS=-l:libpcre2-8.a
make -j$(nproc) $targets