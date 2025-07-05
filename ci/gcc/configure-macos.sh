#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
set -x

export PREFIX="`pwd`/output"

# Build for x86_64
export CFLAGS="-arch x86_64"
export CXXFLAGS="-arch x86_64"
export LDFLAGS="-static-libstdc++ -arch x86_64"

rm -rf build-gcc-x86_64
mkdir build-gcc-x86_64
cd build-gcc-x86_64

../gcc/configure \
    --disable-clocale \
    --disable-gcov \
    --disable-libada \
    --disable-libgomp \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libvtv \
    --disable-multilib \
    --disable-nls \
    --disable-threads \
    --enable-languages=c,c++ \
    --enable-lto \
    --enable-static \
    --prefix="$PREFIX-x86_64" \
    --target=m68k-amiga-elf \
    --with-cpu=68000

cd ..

# Build for arm64
export CFLAGS="-arch arm64"
export CXXFLAGS="-arch arm64"
export LDFLAGS="-static-libstdc++ -arch arm64"

rm -rf build-gcc-arm64
mkdir build-gcc-arm64
cd build-gcc-arm64

../gcc/configure \
    --disable-clocale \
    --disable-gcov \
    --disable-libada \
    --disable-libgomp \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libvtv \
    --disable-multilib \
    --disable-nls \
    --disable-threads \
    --enable-languages=c,c++ \
    --enable-lto \
    --enable-static \
    --prefix="$PREFIX-arm64" \
    --target=m68k-amiga-elf \
    --with-cpu=68000
