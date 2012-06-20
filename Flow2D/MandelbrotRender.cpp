//
//  MandelbrotRender.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "MandelbrotRender.h"

#define USE_ASSEMBLY_IF_AVAILABLE 1
#define USE_ITERATE_STRUCT 1

#if defined (SUPPORT_ASM) && USE_ASSEMBLY_IF_AVAILABLE
    #define USE_ASSEMBLY 1
#endif

const int MandelbrotRender::cMaxIterations = 128;

MandelbrotRender::MandelbrotRender(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper)
:   mTarget(target),
    mRegionToRender(regionToRender),
    mIterationsToRGBAColourMap(colourMapper.rgbaTable())
{
}

void MandelbrotRender::perform()
{
    for (int y=0; y < mTarget.height; y++) {
        for (int x=0; x < mTarget.width; x++) {
            mTarget.buffer[(y * mTarget.width) + x] = colourOfPixel(x, y);
        }
    }    
}

rgbaPixel MandelbrotRender::colourOfPixel(int pixelX, int pixelY)
{
    coord mandelbrotWidth = mRegionToRender.right - mRegionToRender.left;
    coord mandelbrotHeight = mRegionToRender.top - mRegionToRender.bottom;
    
    coord mandelbrotX = mRegionToRender.left + ((pixelX * mandelbrotWidth) / mTarget.width);
    coord mandelbrotY = mRegionToRender.bottom + ((pixelY * mandelbrotHeight) / mTarget.height);

    int iterations = iterationsForEscapeTimeOfPoint(mandelbrotX, mandelbrotY);
    return colourForIteration(iterations);
}

int MandelbrotRender::iterationsForEscapeTimeOfPoint(coord pointX, coord pointY)
{
    int iterations = 0;
    
    coord x = 0;
    coord y = 0;
    coord xSquared;
    coord ySquared;
    
    do {
#ifdef USE_ASSEMBLY
        iterateAssembly(x, y, xSquared, ySquared, pointX, pointY);
#else
        iterate(x, y, xSquared, ySquared, pointX, pointY);
#endif
    }
    while (((xSquared + ySquared) < 4.0) && (++iterations < cMaxIterations));
    
    return iterations;
}

void MandelbrotRender::iterate(coord& x, coord& y, coord& xSquared, coord& ySquared, coord const& pointX, coord const& pointY) const {
    xSquared = x*x;
    ySquared = y*y;
    
    y = 2.0*x*y + pointY;        
    x = xSquared - ySquared + pointX;    
}

#ifdef SUPPORT_ASM
void MandelbrotRender::iterateAssembly(coord& x, coord& y, coord& xSquared, coord& ySquared, coord const& pointX, coord const& pointY) const {

    static const coord two = 2.0;
    
#if USE_ITERATE_STRUCT
    tIterateParameters parameters = { x, y, xSquared, ySquared, pointX, pointY };
#endif    

    asm volatile (
#if USE_ITERATE_STRUCT
                  "fldmiad %0, {d0-d5}     \n\t"
                  "fldmiad %1, {d6}     \n\t"
#else
                  "fldmiad %0, {d0}     \n\t"
                  "fldmiad %1, {d1}     \n\t"
                  "fldmiad %2, {d2}     \n\t"
                  "fldmiad %3, {d3}     \n\t"
                  "fldmiad %4, {d4}     \n\t"
                  "fldmiad %5, {d5}     \n\t"
                  "fldmiad %6, {d6}     \n\t"
#endif                  
                  "fmuld d2, d0, d0     \n\t"   // xSquared = x*x;
                  "fmuld d3, d1, d1     \n\t"   // ySquared = y*y;

                                                // y = 2.0*x*y + pointY;        
                  "fmuld d1, d0, d1     \n\t"   // y = x*y
                  "fmuld d1, d1, d6     \n\t"   // y = x*y*2
                  "faddd d1, d1, d5     \n\t"   // y = x*y*2 + pointY
                  
                                                // x = xSquared - ySquared + pointX;    
                  "fsubd d0, d2, d3     \n\t"   // x = xSqaured - ySquared
                  "faddd d0, d0, d4     \n\t"   // x = xSquared - ySquared + pointX
#if USE_ITERATE_STRUCT                  
                  "fstmiad %0, {d0-d3}    \n\t"
                  :
                  : "r" (&parameters), "r" (&two)
#else
                  "fstmiad %0, {d0}    \n\t"
                  "fstmiad %1, {d1}    \n\t"
                  "fstmiad %2, {d2}    \n\t"
                  "fstmiad %3, {d3}    \n\t"
                  : 
                  : "r" (&x), "r" (&y), "r" (&xSquared), "r" (&ySquared), "r" (&pointX), "r" (&pointY), "r" (&two)
#endif
                  :
                  ); 
    
    x = parameters.x;
    y = parameters.y;
    xSquared = parameters.xSquared;
    ySquared = parameters.ySquared;
}
#endif

rgbaPixel MandelbrotRender::colourForIteration(int iteration)
{
    return mIterationsToRGBAColourMap[iteration];
}



