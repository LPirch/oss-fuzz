#!/bin/bash -eu
targets="$@"
sed -i 's/^AC_CONFIG_MACRO_DIR/#AC_CONFIG_MACRO_DIR/g' configure.ac
autoreconf -fi
./configure --with-openssl
make clean
make -j$(nproc) $targets
