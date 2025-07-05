#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
set -x

export PATH="`brew --prefix bison`/bin:$PATH" # System bison is too old, use homebrew bison
export PREFIX="`pwd`/output"

# Build for x86_64
export CFLAGS="-arch x86_64"
export CXXFLAGS="-arch x86_64"
export LDFLAGS="-L`brew --prefix bison`/lib -static-libstdc++ -arch x86_64"

rm -rf build-binutils-gdb-x86_64
mkdir build-binutils-gdb-x86_64
cd build-binutils-gdb-x86_64

../binutils-gdb/configure \
    --disable-interprocess-agent \
    --disable-libcc \
    --disable-shared \
    --disable-werror \
	--without-guile \
    --enable-static \
	--disable-source-highlight \
    --prefix="$PREFIX-x86_64" \
    --target=m68k-amiga-elf

cd ..

# Build for arm64
export CFLAGS="-arch arm64"
export CXXFLAGS="-arch arm64"
export LDFLAGS="-L`brew --prefix bison`/lib -static-libstdc++ -arch arm64"

rm -rf build-binutils-gdb-arm64
mkdir build-binutils-gdb-arm64
cd build-binutils-gdb-arm64

../binutils-gdb/configure \
    --disable-interprocess-agent \
    --disable-libcc \
    --disable-shared \
    --disable-werror \
	--without-guile \
    --enable-static \
	--disable-source-highlight \
    --prefix="$PREFIX-arm64" \
    --target=m68k-amiga-elf
