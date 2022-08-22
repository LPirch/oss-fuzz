#!/bin/bash -e
targets="$@"

cmake -G"Unix Makefiles" .  -DCMAKE_C_FLAGS="$(gen_cflags)"
