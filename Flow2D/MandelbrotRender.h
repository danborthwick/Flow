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

typedef struct {
    coord x, y;
    coord xSquared, ySquared;
    coord pointX, pointY;
} tIterateParameters;

class MandelbrotRender
{
public:
    static const int cMaxIterations;

protected:
    RGBABuffer const& mTarget;
    MandelbrotRegion const& mRegionToRender;
    rgbaPixel const* mIterationsToRGBAColourMap;
    
public:
    MandelbrotRender(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper);
    
    virtual void perform();

    virtual int iterationsForEscapeTimeOfPoint(coord pointX, coord pointY);

    virtual void iterate(tIterateParameters& parameters) const;
    
    static void logRegionToRender();
    
	void mandelbrotCoordinateFromPixel(const int pixelX, const int pixelY, coord& mandelbrotX, coord& mandelbrotY);
	
protected:
    virtual rgbaPixel colourOfPixel(int pixelX, int pixelY);
    rgbaPixel colourForIteration(int iteration);
};


#endif
