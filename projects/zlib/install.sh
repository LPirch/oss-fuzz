#!/bin/bash -eu

./configure
make -j$(nproc) all
