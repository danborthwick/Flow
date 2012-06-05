//
//  FractalEffect.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_FractalEffect_h
#define Flow2D_FractalEffect_h

#include "Renderable.h"

class MandelbrotRegion
{
public:
    float left;
    float right;
    float top;
    float bottom;
};

class FractalEffect : public Renderable
{
public:
    FractalEffect();
    virtual void render(RGBABuffer const& rgbaBuffer, int elapsedFrames);
    
private:
    MandelbrotRegion mVisibleRegion;
};

class MandelbrotRender
{
private:
    RGBABuffer const& mTarget;
    MandelbrotRegion const& mRegionToRender;
    static const int cMaxIterations;

public:
    MandelbrotRender(RGBABuffer const& target, MandelbrotRegion const& regionToRender);
    void perform();
    
private:    
    rgbaPixel colourOfPixel(int pixelX, int pixelY);
    rgbaPixel colourForIteration(int iteration);
    float iterationsForEscapeTimeOfPoint(float pointX, float pointY);
};

#endif
