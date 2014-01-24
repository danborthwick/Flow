//
//  MandelbrotRender.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "MandelbrotRender.h"

#include "MandelbrotRenderCAssembly.h"

#define USE_ASSEMBLY_IF_AVAILABLE 1

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

#if USE_ASSEMBLY
    int iterations = iterationsForEscapeTimeOfPointAssembly(mandelbrotX, mandelbrotY);
#else    
    int iterations = iterationsForEscapeTimeOfPoint(mandelbrotX, mandelbrotY);
#endif
    return colourForIteration(iterations);
}

int MandelbrotRender::iterationsForEscapeTimeOfPoint(coord pointX, coord pointY)
{
    int iterations = 0;
    
    tIterateParameters parameters = { 0.0, 0.0, 0, 0, pointX, pointY };
    
    do {
#ifdef USE_ASSEMBLY
        iterateAssembly(parameters);
#else
        iterate(parameters);
#endif
    }
    while (((parameters.xSquared + parameters.ySquared) < 4.0) && (++iterations < cMaxIterations));
    
    return iterations;
}

void MandelbrotRender::iterate(tIterateParameters& p) const {
    p.xSquared = p.x * p.x;
    p.ySquared = p.y * p.y;
    
    p.y = 2.0 * p.x * p.y + p.pointY;        
    p.x = p.xSquared - p.ySquared + p.pointX;    
}

#ifdef SUPPORT_ASM

int MandelbrotRender::iterationsForEscapeTimeOfPointAssembly(coord pointX, coord pointY)
{
    return iterationsForEscapeTimeOfPointCAssembly(pointX, pointY);
}

void MandelbrotRender::iterateAssembly(tIterateParameters& parameters) const {

    static const coord two = 2.0;
    
    asm volatile (
                  "vldmia.f64 %0, {d0-d5}  \n\t"
                  "vldmia.f64 %1, {d6}     \n\t"

                  "fmuld d2, d0, d0     \n\t"   // xSquared = x*x;
                  "fmuld d3, d1, d1     \n\t"   // ySquared = y*y;

                                                // y = 2.0*x*y + pointY;        
                  "fmuld d1, d0, d1     \n\t"   // y = x*y
                  "fmuld d1, d1, d6     \n\t"   // y = x*y*2
                  "faddd d1, d1, d5     \n\t"   // y = x*y*2 + pointY
                  
                                                // x = xSquared - ySquared + pointX;    
                  "fsubd d0, d2, d3     \n\t"   // x = xSqaured - ySquared
                  "faddd d0, d0, d4     \n\t"   // x = xSquared - ySquared + pointX

                  "vstmia.f64 %0, {d0-d3}    \n\t"
                  :
                  : "r" (&parameters), "r" (&two)
                  :
                  ); 
}
#endif

rgbaPixel MandelbrotRender::colourForIteration(int iteration)
{
    return mIterationsToRGBAColourMap[iteration];
}



