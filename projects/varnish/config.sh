#!/bin/bash -eux

./autogen.sh
./configure PCRE2_LIBS=-l:libpcre2-8.a CFLAGS="$(gen_cflags)"
