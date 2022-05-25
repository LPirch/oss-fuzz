#!/bin/bash -eu

# build project
./autogen.sh
./configure PCRE2_LIBS=-l:libpcre2-8.a
make -j$(nproc) -C include/
make -j$(nproc) -C lib/libvarnish/
make -j$(nproc) -C lib/libvgz/
make -j$(nproc) -C bin/varnishd/ VSC_main.c 
