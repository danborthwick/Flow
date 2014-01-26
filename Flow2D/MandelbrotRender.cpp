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
    
    tIterateParameters parameters = { 0.0, 0.0, 0, 0, pointX, pointY };
    
    do {
        iterate(parameters);
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

rgbaPixel MandelbrotRender::colourForIteration(int iteration)
{
    return mIterationsToRGBAColourMap[iteration];
}



