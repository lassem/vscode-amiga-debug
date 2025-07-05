#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
set -x

cd elf2hunk

# Build x86_64 version
export CFLAGS="-arch x86_64"
export CXXFLAGS="-arch x86_64"
make clean || true
make
cp elf2hunk elf2hunk-x86_64

# Build arm64 version
export CFLAGS="-arch arm64"
export CXXFLAGS="-arch arm64"
make clean
make
cp elf2hunk elf2hunk-arm64

# Create universal binary
lipo -create elf2hunk-x86_64 elf2hunk-arm64 -output elf2hunk

# Clean up
rm elf2hunk-x86_64 elf2hunk-arm64
