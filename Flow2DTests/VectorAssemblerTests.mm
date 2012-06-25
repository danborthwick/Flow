//
//  VectorAssemblerTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VectorAssemblerTests.h"

#include "Assembly.h"
#include "MandelbrotRender.h"

@implementation VectorAssemblerTests

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#ifdef SUPPORT_ASM
-(void)testWhenTwoDoublesAreSquaredAsVector_thenValuesAreSquared
{
    double d1 = 4.0;
    double d2 = 5.0;
    double squares[2] = { -1.0, -2.0 };
    
    asm volatile (
                  VECTOR_LENGTH(1)
                  "fldmiad %1, {d4}    \n\t"
                  "fldmiad %2, {d5}    \n\t"
                  "fmuld d4, d4, d4    \n\t"
                  "fstmiad %0, {d4-d5}    \n\t"
                  VECTOR_LENGTH_ZERO
                  : 
                  : "r" (squares), "r" (&d1), "r" (&d2)
                  :
                  );
    
    assertThatDouble(squares[0], closeTo(16.0, 0.01));
    assertThatDouble(squares[1], closeTo(25.0, 0.01));
}

-(void)testWhenFourDoublesAreSquaredAsVector_thenValuesAreSquared
{
    double values[4] = { 6.0, 7.0, 8.0, 9.0 };
    double squares[4] = { -1.0, -2.0, -3.0, -4.0 };
    
    asm volatile (
                  VECTOR_LENGTH(3)
                  "fldmiad %1, {d4-d7}  \n\t"
                  "fmuld d4, d4, d4     \n\t"
                  "fstmiad %0, {d4-d7}  \n\t"
                  VECTOR_LENGTH_ZERO
                  : 
                  : "r" (squares), "r" (&values)
                  :
                  );
    
    assertThatDouble(squares[0], closeTo(36.0, 0.01));
    assertThatDouble(squares[1], closeTo(49.0, 0.01));
    assertThatDouble(squares[2], closeTo(64.0, 0.01));
    assertThatDouble(squares[3], closeTo(81.0, 0.01));
}

#endif

@end
