//
//  MandelbrotRender.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "MandelbrotRender.h"


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
    float mandelbrotWidth = mRegionToRender.right - mRegionToRender.left;
    float mandelbrotHeight = mRegionToRender.top - mRegionToRender.bottom;
    
    // Note the 90 degree rotation
    float mandelbrotX = mRegionToRender.left + ((pixelY * mandelbrotWidth) / mTarget.height);
    float mandelbrotY = mRegionToRender.bottom + ((pixelX * mandelbrotHeight) / mTarget.width);
    
    int iterations = iterationsForEscapeTimeOfPoint(mandelbrotX, mandelbrotY);
    return colourForIteration(iterations);
}

float MandelbrotRender::iterationsForEscapeTimeOfPoint(float pointX, float pointY)
{
    int iterations = 0;
    
    float x = 0;
    float y = 0;
    
    while ((x*x + y*y < 2*2) &&  (iterations < cMaxIterations))
    {
        float xTemp = x*x - y*y + pointX;
        y = 2*x*y + pointY;
        
        x = xTemp;
        
        iterations++;
    }
    return iterations;
}

rgbaPixel MandelbrotRender::colourForIteration(int iteration)
{
    return mIterationsToRGBAColourMap[iteration];
}


