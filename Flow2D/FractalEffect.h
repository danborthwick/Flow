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
#include "MandelbrotRender.h"
#include "Renderable.h"

class FractalEffect : public Renderable
{
public:
    FractalEffect();
    virtual void render(RGBABuffer const& rgbaBuffer, int elapsedFrames);
    
private:
    void renderColourMapping(RGBABuffer const& rgbaBuffer);
    
private:
    MandelbrotRegion mVisibleRegion;
    LinearColourMapper* mpColourMapper;
};

#endif
