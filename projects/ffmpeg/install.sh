#!/bin/bash -ux

targets="$@"

# remove Werror flags from configure
sed -ie '/check_cflags\s*-Werror=/d' configure || :

./configure --cc=$CC --extra-cflags="$CFLAGS" \
    --enable-gpl \
    --enable-libass \
    --enable-libfdk-aac \
    --enable-libfreetype \
    --enable-libopus \
    --enable-libtheora \
    --enable-libvorbis \
    --disable-libcdio \
    --enable-nonfree \
    --disable-doc \
    --disable-shared || \
    ./configure --cc=$CC  --extra-cflags="$CFLAGS" # fall-back: default options

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