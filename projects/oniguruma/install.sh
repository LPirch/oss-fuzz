#!/bin/bash -eu

# remove injected fuzzing changes
git checkout -- .

# second command for older versions
./autogen.sh || autoreconf -vfi
./configure
make -j$(nproc)
