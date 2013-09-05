#!/bin/bash

. clang_env
. /usr/GNUstep/System/Library/Makefiles/GNUstep.sh 

if [ -d "test" ]; then
    rm -rf test
fi

mkdir test && cd test

cat > blocktest.m << EOF
#include <stdio.h>

int main() {
    void (^hello)(void) = ^(void) {
        printf("Hello, block!\n");
    };
    hello();
    return 0;
}
EOF

cat > helloGCD_objc.m << EOF

#include <dispatch/dispatch.h>
#import <stdio.h>
#import "Fraction.h"

int main( int argc, const char *argv[] ) {
   dispatch_queue_t queue = dispatch_queue_create(NULL, NULL); 
   Fraction *frac = [[Fraction alloc] init];

   [frac setNumerator: 1];
   [frac setDenominator: 3];

   // print it
   dispatch_sync(queue, ^{
     printf( "Hello, dispatch_sync!\t");
     printf( "The fraction is: " );
     [frac print];
     printf( "\n" );
   });
   dispatch_release(queue);

   return 0;
}

EOF

cat > Fraction.h << EOF

#import <Foundation/NSObject.h>

@interface Fraction: NSObject {
   int numerator;
   int denominator;
}

-(void) print;
-(void) setNumerator: (int) n;
-(void) setDenominator: (int) d;
-(int) numerator;
-(int) denominator;
@end

EOF


cat > Fraction.m << EOF
#import "Fraction.h"
#import <stdio.h>

@implementation Fraction
-(void) print {
   printf( "%i/%i", numerator, denominator );
}

-(void) setNumerator: (int) n {
   numerator = n;
}

-(void) setDenominator: (int) d {
   denominator = d;
}

-(int) denominator {
   return denominator;
}

-(int) numerator {
   return numerator;
}
@end

EOF

clang `gnustep-config --objc-flags` `gnustep-config --objc-libs` -fobj-arc -fobjc-runtime=gnustep -fblocks  -lobjc  blocktest.m -o blocktest

clang `gnustep-config --objc-flags` `gnustep-config --objc-libs` -I/usr/local/include/dispatch -fobj-arc -fobjc-runtime=gnustep -fblocks  -lobjc -ldispatch -lgnustep-base  Fraction.m helloGCD_objc.m -o helloGCD_objc

echo "running test, no crash means the libobjc2 & libdispatch is working..."

cd ..
test/blocktest
test/helloGCD_objc



