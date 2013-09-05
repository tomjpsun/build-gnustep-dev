#!/bin/bash
CWD=`pwd`
# GNUstep with libobjc2
# installation on cleanly installed desktop Debian wheezy(amd64)

git clone git://github.com/nickhutchinson/libdispatch.git 
svn co http://svn.gna.org/svn/gnustep/libs/libobjc2/trunk libobjc2
svn co svn://svn.gna.org/svn/gnustep/modules/ gnustep

source clang_env
clang -v
CC=clang
CXX=clang++


#build libobjc2
cd $CWD/libobjc2
mkdir build && cd build
CC=clang CXX=clang++ cmake ..
CC=clang CXX=clang++ make && sudo -E make install
sudo -E ldconfig

#build gnustep


# - Install GNUstep Make a first time:
cd $CWD/gnustep/core/make
./configure --enable-objc-nonfragile-abi --enable-native-objc-exceptions --with-layout=gnustep --enable-debug-by-default # --prefix=/
make && sudo -E make install
. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh 

# - Build and Install GNUstep Base, Gui and Back:
cd $CWD/gnustep/core/base
# For Linux e.g. Ubuntu, --with-ffi-include is usually required
./configure --with-ffi-include=/usr/include/`gcc -dumpmachine`
make -j 3 && sudo -E make install
#fix: back package can not find base lib
sudo -E ldconfig

cd $CWD/gnustep/core/gui
./configure && make -j 3 && sudo -E make install

cd $CWD/gnustep/core/back
./configure --enable-graphics=cairo && make -j 3 && sudo -E make install

#build libdispatch
cd $CWD/libdispatch
mkdir build && cd build
CC=clang CXX=clang++ cmake ..
CC=clang CXX=clang++ make && sudo -E make install
sudo -E ldconfig
