#!/bin/bash
set -euo pipefail
IFS=$'\n\t'
set -x

# Build x86_64 version
export CFLAGS="-arch x86_64"
export CXXFLAGS="-arch x86_64"
cd build-gcc-x86_64
make all-gcc --jobs 4
make install-gcc
cd ..

# Build arm64 version
export CFLAGS="-arch arm64"
export CXXFLAGS="-arch arm64"
cd build-gcc-arm64
make all-gcc --jobs 4
make install-gcc
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
