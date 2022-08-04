#!/bin/bash -eu
targets="$@"

./config
sed -i "s#^CFLAG=#CFLAG = $CFLAGS #" Makefile
make clean
if [ -z "$targets" ]; then
    make -j$(nproc) || make -j$(nproc) # parallel build fails in older versions but can recover if started again
else
    make $targets
fi
