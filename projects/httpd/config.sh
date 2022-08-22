#!/bin/bash -eux

svn co http://svn.apache.org/repos/asf/apr/apr/trunk srclib/apr
./buildconf
./configure CFLAGS="$(gen_cflags)" --with-included-apr

