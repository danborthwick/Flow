//
//  MandelbrotRenderAssemblyLoop.h
//  Flow2D
//
//  Created by Dan Borthwick on 21/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_MandelbrotRenderAssemblyLoop_h
#define Flow2D_MandelbrotRenderAssemblyLoop_h

#include "MandelbrotRender.h"
#include "Assembly.h"

#ifdef SUPPORT_ASM

class MandelbrotRenderAssemblyLoop : public MandelbrotRender
{
public:
	MandelbrotRenderAssemblyLoop(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper);

    virtual int iterationsForEscapeTimeOfPoint(coord pointX, coord pointY);
};

#endif // SUPPORT_ASM

#endif