//
//  Renderable.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_Renderable_h
#define Flow2D_Renderable_h

#include "RGBABuffer.h"

class Renderable
{
public:
    virtual void render(RGBABuffer const& rgbaBuffer, int elapsedFrames) = 0;
};

#endif
