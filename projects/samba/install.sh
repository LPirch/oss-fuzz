#!/bin/bash -eux
targets="$@"

# It is critical that this script, just as the rest of Samba's GitLab
# CI docker has LANG set to en_US.utf8 (oss-fuzz fails to set this)
if [ -f /etc/default/locale ]; then
	. /etc/default/locale
elif [ -f /etc/locale.conf ]; then
	. /etc/locale.conf
fi
export LANG
export LC_ALL

ADDITIONAL_CFLAGS="$CFLAGS"
export ADDITIONAL_CFLAGS
CFLAGS=""
export CFLAGS
LD="$CXX"
export LD

PYTHON=/usr/bin/python3
export PYTHON
./configure -C --without-gettext --enable-debug --enable-developer \
	--disable-warnings-as-errors \
	--abi-check-disable \
	--nonshared-binary=ALL \
	CFLAGS="$CFLAGS" \
	LINK_CC="$CXX"

make clean
clean_ast_files $OUT

set +e
error_file="${SRC}/errors.log"
make -k -j$(nproc) $targets 2>$error_file
if grep "No rule to make target" $error_file >/dev/null ; then
    make -k -j$(nproc)
fi
if [ -f $error_file ]; then 
    rm $error_file
fi
set -e