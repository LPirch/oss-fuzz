#!/bin/bash -eux

if [ -f "./autogen.sh" ]; then
    # disable failing on warnings
    sed -i 's/-Werror/-Wno-error/g' configure.ac
    ./autogen.sh
fi

CONFIG_SCRIPT="configure"
if [ ! -f ./$CONFIG_SCRIPT ]; then
  CONFIG_SCRIPT="config"
fi
./$CONFIG_SCRIPT CFLAGS="$(gen_cflags)" 
