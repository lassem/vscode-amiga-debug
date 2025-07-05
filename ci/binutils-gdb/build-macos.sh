#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
set -x

export PATH="`brew --prefix bison`/bin:$PATH" # System bison is too old, use homebrew bison

# Temporarily rename libintl dynamic lib to force use of static version
mv $(brew --prefix gettext)/lib/libintl.8.dylib $(brew --prefix gettext)/lib/libintl.8.dylib.bk

# bfd docs fail to build
# we don't need them anyway - create a fake file with a future date so that make skips it
mkdir -p ./build-binutils-gdb-x86_64/bfd/doc/
touch -t 203601010000 ./build-binutils-gdb-x86_64/bfd/doc/bfd.info
mkdir -p ./build-binutils-gdb-arm64/bfd/doc/
touch -t 203601010000 ./build-binutils-gdb-arm64/bfd/doc/bfd.info

# Build x86_64 version
export CFLAGS="-arch x86_64"
export CXXFLAGS="-arch x86_64"
cd build-binutils-gdb-x86_64
make --jobs 4
make install
cd ..

# Build arm64 version
export CFLAGS="-arch arm64"
export CXXFLAGS="-arch arm64"
cd build-binutils-gdb-arm64
make --jobs 4
make install
cd ..

# Create universal binaries using lipo
mkdir -p output
cp -r output-x86_64/* output/

# Find all executables and create universal versions
find output-x86_64 -type f -perm +111 | while read -r file; do
    rel_path="${file#output-x86_64/}"
    arm64_file="output-arm64/$rel_path"
    output_file="output/$rel_path"
    
    if [[ -f "$arm64_file" ]]; then
        echo "Creating universal binary for $rel_path"
        lipo -create "$file" "$arm64_file" -output "$output_file"
    fi
done

# Restore dylib
mv $(brew --prefix gettext)/lib/libintl.8.dylib.bk $(brew --prefix gettext)/lib/libintl.8.dylib
