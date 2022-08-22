#!/bin/bash -eux

# remove wslua from build
if [ -f epan/CMakeLists.txt ]; then
    sed -i '/^\s*\$<TARGET_OBJECTS:wslua>\s*$/d' epan/CMakeLists.txt
fi

mkdir -p build
pushd build
cmake ../ -DDISABLE_WERROR:BOOL=ON -DCMAKE_C_FLAGS="$(gen_cflags)"
popd