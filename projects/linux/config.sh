#!/bin/bash -eu

# patch unknown args for clang
if [ -f arch/x86/Makefile ]; then
        sed -ri 's/^(\s+)(KBUILD_CFLAGS.*maccumulate-outgoing-args)/\1#\2/g' arch/x86/Makefile
fi
if [ -f arch/x86/Makefile_32.cpu ]; then
        sed -ri 's/^(\s*)(.*maccumulate-outgoing-args)/\1#\2/g' arch/x86/Makefile_32.cpu
fi

make CC=clang -j$(nproc) alldefconfig || make CC=clang -j$(nproc) defconfig # defconfig on older versions. alternative: allmodconfig
