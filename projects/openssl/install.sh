#!/bin/bash -eux
targets="$@"

set +u
source $HOME/perl5/perlbrew/etc/bashrc
perlbrew use perl-5.20.3
set -u

make clean
clean_ast_files $OUT
cflags="$(gen_cflags)"

set +e
build_logfile="${WORK}/logs/build.log"
if [ -f $build_logfile ]; then rm $build_logfile; fi
# parallel build fails in older versions but can recover if started again
make CFLAGS="$cflags" -k -j$(nproc) $targets >> $build_logfile 2>&1 || make CFLAGS="$cflags" -k -j$(nproc) $targets >> $build_logfile 2>&1
set -e


