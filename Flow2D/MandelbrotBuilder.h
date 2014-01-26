//
//  MandelbrotBuilder.h
//  Flow2D
//
//  Created by Dan Borthwick on 26/01/2014.
//
//

#ifndef __Flow2D__MandelbrotBuilder__
#define __Flow2D__MandelbrotBuilder__

#include "MandelbrotRender.h"

class MandelbrotBuilder
{
public:
	MandelbrotRender& build(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper);
};

#endif /* defined(__Flow2D__MandelbrotBuilder__) */
