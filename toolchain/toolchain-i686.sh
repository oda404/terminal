#!/bin/bash

export TERMINAL_TOOLCHAIN_ROOT=/home/oda/Documents/cpp/dxgmx-toolchain
export TERMINAL_SOURCE_DIR=/home/oda/Documents/cpp/terminal
export TERMINAL_SYSROOT=$TERMINAL_SOURCE_DIR/sysroot

export CC=$TERMINAL_TOOLCHAIN_ROOT/usr/bin/clang
export AS=$TERMINAL_TOOLCHAIN_ROOT/usr/bin/clang
export LD=$TERMINAL_TOOLCHAIN_ROOT/usr/bin/ld.lld
export NM=$TERMINAL_TOOLCHAIN_ROOT/usr/bin/llvm-nm
export OBJCOPY=$TERMINAL_TOOLCHAIN_ROOT/usr/bin/llvm-objcopy

export HOSTCC=clang
export HOSTCXX=clang++

export CMAKE_TOOLCHAIN_FILE=$TERMINAL_SOURCE_DIR/toolchain/toolchain.cmake
