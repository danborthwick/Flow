//
//  TestEffect.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "TestEffect.h"

void TestEffect::render(RGBABuffer const& rgbaBuffer, int elapsedFrames)
{
    rgbaComponent* rgbaComponents = (rgbaComponent*) rgbaBuffer.buffer;
    int width = rgbaBuffer.width;
    int height = rgbaBuffer.height;
    
    for(int i=0; i < width*height; ++i) {
        rgbaComponents[4*i] = i%width;
        rgbaComponents[4*i+1] = i/width;
        rgbaComponents[4*i+2] = 255;
        rgbaComponents[4*i+3] = 0;
    }
    
    for (int row = 0; row < height; row++) {
        for (int column = 0; column < width; column+=16) {
            rgbaComponents[(4 * ((row * width) + column)) + 0] = elapsedFrames;
            rgbaComponents[(4 * ((row * width) + column)) + 1] = elapsedFrames;
            rgbaComponents[(4 * ((row * width) + column)) + 2] = elapsedFrames;
        }
    }
    
}
