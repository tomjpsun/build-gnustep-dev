build-gnustep-dev
=================

Build GNUstep development environment ( including llvm/clang )

First build stable LLVM/Clang 3.3, by running `llvm-build.sh`. 
It takes some time to download & compile.

Then build GNUstep environment, with libobjc2 and libdispatch supported, 
by running `gs-build.sh`. It takes some time to download.

Finally you can test with the `block-test.sh` script.
If it is not crashing, then our build is working.

