#!/bin/bash -eu
targets="$@"

if [ -f autogen.sh ]; then
  sh autogen.sh --disable-x11
  ./configure --disable-x11 CFLAGS="$CFLAGS"
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
else
  meson setup build
  ninja -C build --clean $targets  # TODO similar mechanism for meson builds
fi