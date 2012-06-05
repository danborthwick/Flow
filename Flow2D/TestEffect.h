//
//  TestEffect.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_TestEffect_h
#define Flow2D_TestEffect_h

#include "Renderable.h"

class TestEffect : public Renderable
{
    virtual void render(RGBABuffer const& rgbaBuffer, int elapsedFrames);
};

#endif
