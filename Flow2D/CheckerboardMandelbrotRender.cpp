//
//  CheckerboardMandelbrotRenderer.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 26/01/2014.
//
//

#include "CheckerboardMandelbrotRender.h"

CheckerboardMandelbrotRender::CheckerboardMandelbrotRender(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper)
:	MandelbrotRender(target, regionToRender, colourMapper)
{
	
}

void CheckerboardMandelbrotRender::perform()
{
    for (int y=0; y < mTarget.height; y++) {
        for (int x=0; x < mTarget.width; x++) {
            mTarget.buffer[(y * mTarget.width) + x] = colourOfPixel(x, y);
        }
    }
}

rgbaPixel CheckerboardMandelbrotRender::colourOfPixel(int pixelX, int pixelY)
{
	return ((pixelX % 2) + (pixelY % 2) == 0) ? cWhite : cBlack;
}

