//
//  FractalEffect.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "FractalEffect.h"

FractalEffect::FractalEffect()
{
    mVisibleRegion.left = -2;
    mVisibleRegion.right = 1.5;
    mVisibleRegion.top = 1;
    mVisibleRegion.bottom = -1;
}

void FractalEffect::render(RGBABuffer const& rgbaBuffer, int elapsedFrames)
{
    MandelbrotRender render(rgbaBuffer, mVisibleRegion);
    render.perform();
}

//------------------------------------

const int MandelbrotRender::cMaxIterations = 1000;

MandelbrotRender::MandelbrotRender(RGBABuffer const& target, MandelbrotRegion const& regionToRender)
:   mTarget(target),
    mRegionToRender(regionToRender)
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
    
    float mandelbrotX = mRegionToRender.left + ((pixelX * mandelbrotWidth) / mTarget.width);
    float mandelbrotY = mRegionToRender.bottom + ((pixelY * mandelbrotHeight) / mTarget.height);
    
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
    rgbaPixel pixel;
    rgbaComponent* components = (rgbaComponent*) &pixel;
    rgbaComponent clampedIteration = iteration & 0xff;
    components[0] = components[1] = components[2] = components[3] = clampedIteration;
    return pixel;
}


