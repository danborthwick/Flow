//
//  SmoothMandelbrotRender.h
//  Flow2D
//
//  Created by Dan Borthwick on 26/01/2014.
//
//

#ifndef __Flow2D__SmoothMandelbrotRender__
#define __Flow2D__SmoothMandelbrotRender__

#include "MandelbrotRender.h"

class SmoothMandelbrotRender : public MandelbrotRender
{
public:
	SmoothMandelbrotRender(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper);
	
    virtual void perform();
	
protected:
	virtual rgbaPixel colourOfPixel(int pixelX, int pixelY);
};

#endif /* defined(__Flow2D__SmoothMandelbrotRender__) */
