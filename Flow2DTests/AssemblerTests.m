//
//  AssemblerTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AssemblerTests.h"

#include "Assembly.h"

@implementation AssemblerTests

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#ifdef SUPPORT_ASM
-(void)testWhenTwoIntsAreAdded_thenResultIsTheirSum
{
    int source = 19;
    int sum = 0;
    
    asm volatile (
                  "add %0, %1, #42    \n\t"
                  : "=r" (sum)
                  : "r" (source)
                  :
                  );
    
    assertThatInt(sum, equalToInt(61));
}

-(void)testWhenTwoFloatsAreMultiplied_thenResultIsTheirProduct
{
    float f1 = 5.0f;
    float f2 = 7.0f;
    float product = 0;
    
    asm volatile (
                  "fldmias %1, {s1}    \n\t"    // f1->s1
                  "fldmias %2, {s2}    \n\t"    // f2->s2
                  "fmuls s0, s1, s2    \n\t"    // s0 = f1*f2
                  "fstmias %0, {s0}    \n\t"    // s0->product
                  : 
                  : "r" (&product), "r" (&f1), "r" (&f2)
                  :
                  );
    
    assertThatFloat(product, equalToFloat(35.0f));
}

-(void)testWhenTwoDoublesAreMultiplied_thenResultIsTheirProduct
{
    double d1 = 4.0;
    double d2 = 5.0;
    double product = 0;
    
    asm volatile (
                  "fldmiad %1, {d1}    \n\t"    // f1->s1
                  "fldmiad %2, {d2}    \n\t"    // f2->s2
                  "fmuld d0, d1, d2    \n\t"    // s0 = f1*f2
                  "fstmiad %0, {d0}    \n\t"    // s0->product
                  : 
                  : "r" (&product), "r" (&d1), "r" (&d2)
                  :
                  );
    
    assertThatFloat(product, equalToFloat(20.0f));
}

#endif

@end
