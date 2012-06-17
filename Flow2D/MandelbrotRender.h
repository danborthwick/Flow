//
//  MandelbrotRender.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_MandelbrotRender_h
#define Flow2D_MandelbrotRender_h

#include "LinearHSVColourMapper.h"
#include "RGBABuffer.h"
#include "MandelbrotRegion.h"

typedef double coord;

class MandelbrotRender
{
public:
    static const int cMaxIterations;

private:
    RGBABuffer const& mTarget;
    MandelbrotRegion const& mRegionToRender;
    rgbaPixel const* mIterationsToRGBAColourMap;
    
public:
    MandelbrotRender(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper);
    
    void perform();
    
    static void logRegionToRender();
    
private:    
    rgbaPixel colourOfPixel(int pixelX, int pixelY);
    rgbaPixel colourForIteration(int iteration);
    int iterationsForEscapeTimeOfPoint(coord pointX, coord pointY);
};


#endif
