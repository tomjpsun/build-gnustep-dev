#!/bin/bash
CWD=`pwd`
# Dependencies
sudo aptitude install build-essential git subversion ninja cmake
# Dependencies for GNUStep Base
sudo aptitude install libffi-dev libxml2-dev libgnutls-dev libicu-dev 
# Dependencies for libdispatch
sudo aptitude install libblocksruntime-dev libkqueue-dev libpthread-workqueue-dev autoconf libtool

#checkout llvm
svn co http://llvm.org/svn/llvm-project/llvm/tags/RELEASE_33/final llvm
#checkout clang
cd llvm/tools
svn co http://llvm.org/svn/llvm-project/cfe/tags/RELEASE_33/final clang
cd ../..
#checkout extra clang tools
cd llvm/tools/clang/tools
svn co http://llvm.org/svn/llvm-project/clang-tools-extra/tags/RELEASE_33/final extra
cd ../../../..
#checkout compiler-rt
cd llvm/projects
svn co http://llvm.org/svn/llvm-project/compiler-rt/tags/RELEASE_33/final compiler-rt

cd ../..
#build llvm+clang
mkdir build-llvm
cd build-llvm
../llvm/configure  --enable-optimized
make -j4   # 8=your number of build CPUs

cd $CWD
echo "export PATH=\$PATH:`pwd`/build-llvm/Release+Asserts/bin" >> clang_env
echo "export CC=clang"  >> clang_env
echo "export CXX=clang++" >> clang_env
source clang_env
clang -v
clang++ -v

