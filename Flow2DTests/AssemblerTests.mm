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

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@implementation AssemblerTests


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
                  "vldmia.f32 %1, {s1}    \n\t"    // f1->s1
                  "vldmia.f32 %2, {s2}    \n\t"    // f2->s2
                  "fmuls s0, s1, s2    \n\t"    // s0 = f1*f2
                  "vstmia.f32 %0, {s0}    \n\t"    // s0->product
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
                  "vldmia.f64 %1, {d1}    \n\t"    // f1->s1
                  "vldmia.f64 %2, {d2}    \n\t"    // f2->s2
                  "fmuld d0, d1, d2    \n\t"    // s0 = f1*f2
                  "vstmia.f64 %0, {d0}    \n\t"    // s0->product
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
                  "vldmia.f64 %2, {d1-d2}  \n\t"
                  "vstmia.f64 %0, {d1}     \n\t"
                  "vstmia.f64 %1, {d2}     \n\t"
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
                  "vldmia.f64 %0, {d1}  \n\t"
                  "vldmia.f64 %1, {d2}     \n\t"
                  "vstmia.f64 %2, {d1-d2}     \n\t"
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
                  "vldmia.f64 %0, {d0}     \n\t"
                  "vldmia.f64 %1, {d1}     \n\t"
                  "vldmia.f64 %2, {d2}     \n\t"
                  "vldmia.f64 %3, {d3}     \n\t"
                  "vldmia.f64 %4, {d4}     \n\t"
                  "vldmia.f64 %5, {d5}     \n\t"
                  
                  "vstmia.f64 %6, {d0-d5}  \n\t"
                  :
                  : "r" (&x), "r" (&y), "r" (&xSquared), "r" (&ySquared), "r" (&pointX), "r" (&pointY), "r" (&params)
                  :
                  );
    
    assertThatDouble(params.x, equalToDouble(x));
    assertThatDouble(params.y, equalToDouble(y));
    assertThatDouble(params.xSquared, equalToDouble(xSquared));
    assertThatDouble(params.ySquared, equalToDouble(ySquared));
    assertThatDouble(params.pointX, equalToDouble(pointX));
    assertThatDouble(params.pointY, equalToDouble(pointY));
}

-(void)testWhenAnIntConstantIsSetToRegister_thenSavedRegisterHasValue
{
    int savedInt;
    
    asm volatile (
                  "mov %0, #2    \n\t"
                  : "=r" (savedInt)
                  :
                  :
                  );
    
    assertThatInt(savedInt, equalToInt(2));
}

/*
-(void)testWhenAnFloatConstantIsSetToRegister_thenSavedRegisterHasValue
{
    int savedInt;
    
    asm volatile (
                  "vldr d0, =1.23E10   \n\t"
                  //"fldd d0, =1.23E10   \n\t"
                  //"vstmia.f64 %0, =1.23E10       \n\t"
                  :
                  : "r" (&savedInt)
                  :
                  );
    
    assertThatInt(savedInt, equalToInt(2));
}*/

-(void)testWhenALoopIsRunTenTimes_thenCounterEqualsTen
{
    int count = 0;
    int loopsRemaining = 10;
    
    asm volatile (
                  "LSTART:      \n\t"
                  "add %0, %0, #1   \n\t"
                  "subs %1, %1, #1   \n\t"
                  "bne LSTART   \n\t"
                  : "=r" (count), "=r" (loopsRemaining)
                  : "0" (count), "1" (loopsRemaining)
                  :
                  );
    
    assertThatInt(loopsRemaining, equalToInt(0));
    assertThatInt(count, equalToInt(10));
}

-(void)testWhenAFloatLoopIsRunTenTimes_thenCounterEqualsTen
{
    float count = 0.0;
    float loopsRemaining = 10.0;
    float zero = 0.0;
    float one = 1.0;
    
    asm volatile (
                  "vldmia.f32 %0, {s0}  \n\t" //count
                  "vldmia.f32 %1, {s1}  \n\t" //loopsRemaining
                  "vldmia.f32 %2, {s2}  \n\t" //zero
                  "vldmia.f32 %3, {s3}  \n\t" //one
                  
                  "LFLOATLOOPSTART:      \n\t"
                  "fadds s0, s0, s3  \n\t"
                  "fsubs s1, s1, s3  \n\t"
                  "fcmps s1, s2  \n\t"
                  
                  "fcmps s1, s2     \n\t"
                  "fmstat           \n\t"
                  "bne LFLOATLOOPSTART   \n\t"
                  
                  "vstmia.f32 %0, {s0}    \n\t"
                  "vstmia.f32 %1, {s1}    \n\t"
                  : 
                  : "r" (&count), "r" (&loopsRemaining), "r" (&zero), "r" (&one)
                  :
                  );
    
    assertThatFloat(loopsRemaining, equalToFloat(0.0));
    assertThatFloat(count, equalToFloat(10.0));
}

-(void)testWhenADoubleLoopIsRunTenTimes_thenCounterEqualsTen
{
    double count = 0.0;
    double loopsRemaining = 10.0;
    double zero = 0.0;
    double one = 1.0;
    
    asm volatile (
                  "vldmia.f64 %0, {d0}  \n\t" //count
                  "vldmia.f64 %1, {d1}  \n\t" //loopsRemaining
                  "vldmia.f64 %2, {d2}  \n\t" //zero
                  "vldmia.f64 %3, {d3}  \n\t" //one
                  
                  "LDOUBLELOOPSTART:      \n\t"
                  "faddd d0, d0, d3  \n\t"
                  "fsubd d1, d1, d3  \n\t"
                  "fcmpd d1, d2  \n\t"
                  
                  "fcmpd d1, d2     \n\t"
                  "fmstat           \n\t"
                  "bne LDOUBLELOOPSTART   \n\t"
                  
                  "vstmia.f64 %0, {d0}    \n\t"
                  "vstmia.f64 %1, {d1}    \n\t"
                  : 
                  : "r" (&count), "r" (&loopsRemaining), "r" (&zero), "r" (&one)
                  :
                  );
    
    assertThatDouble(loopsRemaining, equalToDouble(0.0));
    assertThatDouble(count, equalToDouble(10.0));
}

-(void)testWhenAssemblyTestingFirstDoubleWhoseSquareIsAtLeastFour_thenTwoIsReturned
{
    double result = 0.0;
    const double pointOne = 0.1;
    const double four = 4.0;
    
    asm volatile (
                  "vldmia.f64 %0, {d0}     \n\t"
                  "vldmia.f64 %1, {d1}     \n\t"
                  "vldmia.f64 %2, {d2}     \n\t"
                
                  "LSQUARELOOPSTART:    \n\t"
                  "faddd d0, d0, d1     \n\t"
                  "fmuld d3, d0, d0     \n\t"
                  
                  "fcmpd d3, d2         \n\t"
                  "fmstat               \n\t"
                  "blt LSQUARELOOPSTART \n\t"
                  
                  "vstmia.f64 %0, {d0}     \n\t"
                  :
                  : "r" (&result), "r" (&pointOne), "r" (&four)
                  :
                  );
    
    assertThatDouble(result, closeTo(2.0, 0.0001));
}

#endif

@end
