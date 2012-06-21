//
//  MandelbrotRenderCAssembly.c
//  Flow2D
//
//  Created by Dan Borthwick on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "MandelbrotRenderCAssembly.h"

#include "MandelbrotRender.h"

int iterationsForEscapeTimeOfPointCAssembly(double pointX, double pointY)
{
    static const double two = 2.0;
    static const double four = 4.0;
    static const double zero = 0.0;
    int iterations = MandelbrotRender::cMaxIterations;
    
    /*    do {
     iterateAssembly(parameters);
     }
     while (((parameters.xSquared + parameters.ySquared) < 4.0) && (--iterations));
     */    
    asm volatile (
                  "fldmiad %5, {d0}     \n\t"   // x = 0
                  "fldmiad %5, {d1}     \n\t"   // y = 0
                  //            d2                 xSquared
                  //            d3                 ySquared
                  "fldmiad %1, {d4}     \n\t"   // pointX
                  "fldmiad %2, {d5}     \n\t"   // pointY
                  "fldmiad %3, {d6}     \n\t"   // two
                  "fldmiad %4, {d7}     \n\t"   // four
                  
                  "LOOP_START:          \n\t"
                  
                  "fmuld d2, d0, d0     \n\t"   // xSquared = x*x;
                  "fmuld d3, d1, d1     \n\t"   // ySquared = y*y;
                  
                  // y = 2.0*x*y + pointY;        
                  "fmuld d1, d0, d1     \n\t"   // y = x*y
                  "fmuld d1, d1, d6     \n\t"   // y = x*y*2
                  "faddd d1, d1, d5     \n\t"   // y = x*y*2 + pointY
                  
                  // x = xSquared - ySquared + pointX;    
                  "fsubd d0, d2, d3     \n\t"   // x = xSqaured - ySquared
                  "faddd d0, d0, d4     \n\t"   // x = xSquared - ySquared + pointX

                  // while(--iterations)
                  "subs %0, %0, #1      \n\t"
                  "beq LOOP_BREAK       \n\t"

                  // while ((parameters.xSquared + parameters.ySquared) < 4.0)
                  "faddd d8, d2, d3     \n\t"   // d8 = xSquared + ySquared
                  "fcmpd d8, d7         \n\t"       // if d8<4
                  "fmstat               \n\t"
                  "blt LOOP_START       \n\t"
                  
                  "LOOP_BREAK:          \n\t"
                  
                  : "=r" (iterations)
                  : "r" (&pointX), "r" (&pointY), "r" (&two), "r" (&four), "r" (&zero), "0" (iterations)
                  : "r9", "d0", "d1", "d2", "d3", "d4", "d5", "d6", "d7", "d8"
                  ); 
    
    return MandelbrotRender::cMaxIterations - iterations;
}


