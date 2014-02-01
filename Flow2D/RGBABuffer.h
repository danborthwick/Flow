//
//  RGBABuffer.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_RGBABuffer_h
#define Flow2D_RGBABuffer_h

#include "Colour.h"

class RGBABuffer
{
public:
    rgbaPixel* buffer;
    int width;
    int height;
};

#endif
