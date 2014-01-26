//
//  CheckerboardMandelbrotRenderer.h
//  Flow2D
//
//  Created by Dan Borthwick on 26/01/2014.
//
//

#ifndef __Flow2D__CheckerboardMandelbrotRenderer__
#define __Flow2D__CheckerboardMandelbrotRenderer__

#include "MandelbrotRender.h"

class CheckerboardMandelbrotRender : public MandelbrotRender
{
public:
	CheckerboardMandelbrotRender(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper);

    virtual void perform();
	
private:
	rgbaPixel colourOfPixel(int pixelX, int pixelY);
};

#endif /* defined(__Flow2D__CheckerboardMandelbrotRenderer__) */
