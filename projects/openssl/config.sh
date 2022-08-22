#!/bin/bash -eux

set +u
source $HOME/perl5/perlbrew/etc/bashrc
perlbrew use perl-5.20.3
set -u

cflags="$(gen_cflags)"
CFLAGS="${cflags}" ./config
sed -i "s#^CFLAG=#CFLAG = $cflags #" Makefile
