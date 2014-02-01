//
//  SmoothMandelbrotRender.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 26/01/2014.
//
//

#include "SmoothMandelbrotRender.h"

#import <math.h>

SmoothMandelbrotRender::SmoothMandelbrotRender(RGBABuffer const& target,
											   MandelbrotRegion const& regionToRender,
											   LinearColourMapper const& colourMapper)
:	MandelbrotRender(target, regionToRender, colourMapper)
{
	
}

void SmoothMandelbrotRender::perform()
{
    for (int y=0; y < mTarget.height; y++) {
        for (int x=0; x < mTarget.width; x++) {
            mTarget.buffer[(y * mTarget.width) + x] = colourOfPixel(x, y);
        }
    }
}

rgbaPixel SmoothMandelbrotRender::colourOfPixel(int pixelX, int pixelY)
{
	coord mandelbrotX, mandelbrotY;
	mandelbrotCoordinateFromPixel(pixelX, pixelY, mandelbrotX, mandelbrotY);

	int iterations = 0;
    
    tIterateParameters p = { 0.0, 0.0, 0, 0, mandelbrotX, mandelbrotY };
    
    do {
		p.xSquared = p.x * p.x;
		p.ySquared = p.y * p.y;
		
		p.y = 2.0 * p.x * p.y + p.pointY;
		p.x = p.xSquared - p.ySquared + p.pointX;
    }
    while (((p.xSquared + p.ySquared) < 2<<16) && (++iterations < cMaxIterations));
    
	double fractionalIterations = iterations;
	
	if (iterations < cMaxIterations) {
		coord zn = sqrt(p.xSquared + p.ySquared);
		coord nu = log( log(zn) / log(2) ) / log(2);
		// Rearranging the potential function.
		// Could remove the sqrt and multiply log(zn) by 1/2, but less clear.
		// Dividing log(zn) by log(2) instead of log(N = 2<<16)
		// because we want the entire palette to range from the
		// center to radius 2, NOT our bailout radius.
		fractionalIterations += 1.0 - nu;
	}
	double flooredIterations;
	
	rgbaPixel color1 = colourForIteration(floor(fractionalIterations));
	rgbaPixel color2 = colourForIteration(floor(fractionalIterations) + 1);
	// iteration % 1 = fractional part of iteration.
	return interpolateColour(color1, color2, modf(fractionalIterations, &flooredIterations));
}