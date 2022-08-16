#!/bin/bash -eu
targets="$@"
# patch unknown args for clang
if [ -f arch/x86/Makefile ]; then
        sed -ri 's/^(\s+)(KBUILD_CFLAGS.*maccumulate-outgoing-args)/\1#\2/g' arch/x86/Makefile
fi
if [ -f arch/x86/Makefile_32.cpu ]; then
        sed -ri 's/^(\s*)(.*maccumulate-outgoing-args)/\1#\2/g' arch/x86/Makefile_32.cpu
fi

make CC=clang -j$(nproc) alldefconfig || make CC=clang -j$(nproc) defconfig # defconfig on older versions. alternative: allmodconfig
make clean
clean_ast_files $OUT

set +e
build_logfile="${WORK}/logs/build.log"
make -k -j$(nproc) CC=clang EXTRA_CFLAGS="$CFLAGS -no-integrated-as -f-fno-zero-initialized-in-bss" $targets >> $build_logfile 2>&1
if grep "No rule to make target" $build_logfile >/dev/null ; then
    make -k -j$(nproc) CC=clang EXTRA_CFLAGS="$CFLAGS -no-integrated-as -f-fno-zero-initialized-in-bss"  >> $build_logfile 2>&1
fi
set -e
