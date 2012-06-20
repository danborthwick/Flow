//
//  AssemblerTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AssemblerTests.h"

#include "Assembly.h"
#include "MandelbrotRender.h"

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
    
    assertThatDouble(product, equalToDouble(20.0f));
}

-(void)testWhenAStructIsLoaded_thenSavedResultsAreAsExpected
{
    double result0, result1;
    typedef struct { double a; double b; } tStruct;
    tStruct s = { 3.4, 5.6 };
    
    asm volatile (
                  "fldmiad %2, {d1-d2}  \n\t"
                  "fstmiad %0, {d1}     \n\t"
                  "fstmiad %1, {d2}     \n\t"
                  :
                  : "r" (&result0), "r" (&result1), "r" (&s)
                  :
                  );
    
    assertThatDouble(result0, equalToDouble(3.4));
    assertThatDouble(result1, equalToDouble(5.6));
}

-(void)testWhenAStructIsSaved_thenFieldsEqualLoadedValues
{
    double expected0 = 1.2;
    double expected1 = 3.4;
    struct { double a; double b; } s;
    
    asm volatile (
                  "fldmiad %0, {d1}  \n\t"
                  "fldmiad %1, {d2}     \n\t"
                  "fstmiad %2, {d1-d2}     \n\t"
                  :
                  : "r" (&expected0), "r" (&expected1), "r" (&s)
                  :
                  );
    
    assertThatDouble(s.a, equalToDouble(expected0));
    assertThatDouble(s.b, equalToDouble(expected1));
}

-(void)testWhenAnIterateParametersStructIsSaved_thenFieldsEqualLoadedValues
{
    tIterateParameters params;
    double x=1.0, y=2.0, xSquared=3.0, ySquared=4.0, pointX=5.0, pointY=6.0;
    
    asm volatile (
                  "fldmiad %0, {d0}     \n\t"
                  "fldmiad %1, {d1}     \n\t"
                  "fldmiad %2, {d2}     \n\t"
                  "fldmiad %3, {d3}     \n\t"
                  "fldmiad %4, {d4}     \n\t"
                  "fldmiad %5, {d5}     \n\t"
                  
                  "faddd d2, d3, d4     \n\t"
                  
                  "fstmiad %6, {d0-d5}  \n\t"
                  :
                  : "r" (&x), "r" (&y), "r" (&xSquared), "r" (&ySquared), "r" (&pointX), "r" (&pointY), "r" (&params)
                  :
                  );
    
    assertThatDouble(params.x, equalToDouble(x));
    assertThatDouble(params.y, equalToDouble(y));
//    assertThatDouble(params.xSquared, equalToDouble(xSquared));
    assertThatDouble(params.xSquared, equalToDouble(9.0));
    assertThatDouble(params.ySquared, equalToDouble(ySquared));
    assertThatDouble(params.pointX, equalToDouble(pointX));
    assertThatDouble(params.pointY, equalToDouble(pointY));
}

#endif

@end
