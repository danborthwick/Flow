//
//  MandelbrotBuilder.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 26/01/2014.
//
//

#include "MandelbrotBuilder.h"
#include "Assembly.h"
#include "CheckerboardMandelbrotRender.h"
#include "MandelbrotRenderAssemblyLoop.h"

MandelbrotRender& MandelbrotBuilder::build(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper)
{
	return *new CheckerboardMandelbrotRender(target, regionToRender, colourMapper);
/*
#ifdef SUPPORT_ASM
	return *new MandelbrotRenderAssemblyLoop(target, regionToRender, colourMapper);
#else
	return *new MandelbrotRender(target, regionToRender, colourMapper);
#endif
 */
}
