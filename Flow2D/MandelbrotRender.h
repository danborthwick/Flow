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

#include "Assembly.h"

typedef double coord;

typedef struct {
    coord x, y;
    coord xSquared, ySquared;
    coord pointX, pointY;
} tIterateParameters;

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

    int iterationsForEscapeTimeOfPoint(coord pointX, coord pointY);

    void iterate(coord& x, coord& y, coord& xSquared, coord& ySquared, coord const& pointX, coord const& pointY) const;
    
#ifdef SUPPORT_ASM
    void iterateAssembly(coord& x, coord& y, coord& xSquared, coord& ySquared, coord const& pointX, coord const& pointY) const;
#endif
    
    static void logRegionToRender();
    
private:    
    rgbaPixel colourOfPixel(int pixelX, int pixelY);
    rgbaPixel colourForIteration(int iteration);
};


#endif
