//
//  MandelbrotRenderCAssembly.c
//  Flow2D
//
//  Created by Dan Borthwick on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "MandelbrotRenderCAssembly.h"

#include "MandelbrotRender.h"

#ifdef SUPPORT_ASM

int iterationsForEscapeTimeOfPointCAssembly(double pointX, double pointY)
{
    static const double four = 4.0;
    int iterations = MandelbrotRender::cMaxIterations;
    
    /*    do {
        y => 2xy + pointY
        x => x^2 - y^2 + pointX
     }
     while (((parameters.xSquared + parameters.ySquared) < 4.0) && (--iterations));
     */    
    asm volatile (
                  //            d0                 x
                  //            d1                 y
                  //            d2                 xSquared
                  //            d3                 ySquared
                  "vldmia.f64 %1, {d4}     \n\t"   // pointX
                  "vldmia.f64 %2, {d5}     \n\t"   // pointY
                  "vldmia.f64 %3, {d6}     \n\t"   // four
                  
                  "fsubd d0, d0, d0     \n\t"   // x=0
                  "fsubd d1, d1, d1     \n\t"   // y=0
                  
                  "LOOP_START:          \n\t"
                                    
                  "fmuld d2, d0, d0     \n\t"   // xSquared = x*x;
                  "fmuld d3, d1, d1     \n\t"   // ySquared = y*y;
                  
                  // y = 2.0*x*y + pointY;
                  "faddd d1, d1, d1     \n\t"   // y = 2*y
                  "fmuld d1, d0, d1     \n\t"   // y = 2*x*y
                  "faddd d1, d1, d5     \n\t"   // y = x*y*2 + pointY
                  
                  // x = xSquared - ySquared + pointX;    
                  "fsubd d0, d2, d3     \n\t"   // x = xSquared - ySquared
                  "faddd d0, d0, d4     \n\t"   // x = xSquared - ySquared + pointX

                  // while(--iterations)
                  "subs %0, %0, #1      \n\t"
                  "beq LOOP_BREAK       \n\t"

                  // while ((parameters.xSquared + parameters.ySquared) < 4.0)
                  "faddd d8, d2, d3     \n\t"   // d8 = xSquared + ySquared
                  "fcmpd d8, d6         \n\t"       // if d8<4
                  "fmstat               \n\t"
                  "blt LOOP_START       \n\t"
                  
                  "LOOP_BREAK:          \n\t"
                  
                  : "=r" (iterations)
                  : "r" (&pointX), "r" (&pointY), "r" (&four), "0" (iterations)
                  : "d0", "d1", "d2", "d3", "d4", "d5", "d6", "d8"
                  ); 
    
    return MandelbrotRender::cMaxIterations - iterations;
}

#endif