//
//  FractalEffect.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FractalEffect.h"

#include "math.h"

FractalEffect::FractalEffect()
{
    mVisibleRegion.left = -2;
    mVisibleRegion.right = 1;
    mVisibleRegion.top = -1;
    mVisibleRegion.bottom = 1;
    
//    setTestRegion();
    
//    mpColourMapper = new GreyscaleColourMapper(MandelbrotRender::cMaxIterations, 32);
    mpColourMapper = new HSVColourMapper(MandelbrotRender::cMaxIterations, 128);
}

void FractalEffect::render(RGBABuffer const& rgbaBuffer, int elapsedFrames)
{
    MandelbrotRender& render = mBuilder.build(rgbaBuffer, mVisibleRegion, *mpColourMapper);
    render.perform();
	delete &render;
    
//    renderColourMapping(rgbaBuffer);
}

void FractalEffect::renderColourMapping(const RGBABuffer &rgbaBuffer)
{
    const int stripeWidth = 16;
    const int stripeHeight = fminf(rgbaBuffer.height, MandelbrotRender::cMaxIterations);
    
    for (int y=0; y<stripeHeight; y++) {
        rgbaPixel colour = mpColourMapper->rgbaTable()[y];
        
        for (int x=0; x<stripeWidth; x++) {
            rgbaBuffer.buffer[(y * rgbaBuffer.width) + x] = colour;
        }
    }
}

MandelbrotRegion const& FractalEffect::visibleRegion() const
{
    return mVisibleRegion;
}

void FractalEffect::setVisibleRegion(MandelbrotRegion const& newVisibleRegion)
{
    mVisibleRegion = newVisibleRegion;
}

void FractalEffect::setTestRegion()
{
    mVisibleRegion.left =   -0.740217328072f;
    mVisibleRegion.right =  -0.740213274956f;
    mVisibleRegion.top =    -0.184914901853f;
    mVisibleRegion.bottom = -0.184912174940f;
}
