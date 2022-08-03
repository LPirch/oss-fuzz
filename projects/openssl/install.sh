#!/bin/bash -eu

./config
sed -i "s#^CFLAG=#CFLAG = $CFLAGS #" Makefile
make -j$(nproc) || make -j$(nproc) # parallel build fails in older versions but can recover if started again
