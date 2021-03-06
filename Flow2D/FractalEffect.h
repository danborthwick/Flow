//
//  FractalEffect.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_FractalEffect_h
#define Flow2D_FractalEffect_h

#include "LinearHSVColourMapper.h"
#include "MandelbrotBuilder.h"
#include "MandelbrotRender.h"
#include "Renderable.h"

class FractalEffect : public Renderable
{
public:
    FractalEffect();
    virtual void render(RGBABuffer const& rgbaBuffer, int elapsedFrames);
    MandelbrotRegion const& visibleRegion() const;
    void setVisibleRegion(MandelbrotRegion const& newVisibleRegion);
    
private:
    void renderColourMapping(RGBABuffer const& rgbaBuffer);
    void setTestRegion();
    
private:
	MandelbrotBuilder mBuilder;
    MandelbrotRegion mVisibleRegion;
    LinearColourMapper* mpColourMapper;
};

#endif
