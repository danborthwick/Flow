//
//  MandelbrotRenderAssemblySingleIteration.h
//  Flow2D
//
//  Created by Dan Borthwick on 26/01/2014.
//
//

#ifndef __Flow2D__MandelbrotRenderAssemblySingleIteration__
#define __Flow2D__MandelbrotRenderAssemblySingleIteration__

#include "Assembly.h"

#include "MandelbrotRender.h"

#ifdef SUPPORT_ASM

class MandelbrotRenderAssemblySingleIteration : public MandelbrotRender
{
public:
	MandelbrotRenderAssemblySingleIteration(RGBABuffer const& target, MandelbrotRegion const& regionToRender, LinearColourMapper const& colourMapper);

    virtual void iterate(tIterateParameters& parameters) const;
};

#endif // SUPPORT_ASM

#endif /* defined(__Flow2D__MandelbrotRenderAssemblySingleIteration__) */
