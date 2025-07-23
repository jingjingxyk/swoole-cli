#!/usr/bin/env bash
set -x


export CC=/usr/bin/clang
export CXX=/usr/bin/clang++

export CC=/usr/bin/gcc
export CXX=/usr/bin/g++


clang++ --version | grep "clang version"
gcc --version
cmake --version
ninja --version

# 获得c++ 版本
g++ -dM -E -x c++ /dev/null | grep __cplusplus

# rm -rf gcm.cache CMakeCache.txt CMakeFiles

# mkdir -p gcm.cache
# g++ -std=c++26 -fmodules -fsearch-include-path -c bits/std.cc

# g++ -std=c++23 -fmodules-ts -xc++-system-header iostream vector

ls gcm.cache/std.gcm


# 手动编译
# g++ -std=c++26 -fmodules main.cpp

# test -d build && rm -rf build
mkdir -p build

cmake -S . -B build -G "Ninja" -DCMAKE_BUILD_TYPE=Debug -DCMAKE_MESSAGE_LOG_LEVEL=VERBOSE
ninja -C build
# ninja -C build install
./build/untitled


exit 0
cmake -S . -B build
cmake --build  build --parallel $(nproc)

ls -lh build

# macos

ls ~/Applications/CLion.app/Contents/bin/