//
//  LinearHSVColourMapper.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "LinearHSVColourMapper.h"

#include "math.h"
#include "stdlib.h"

void LinearColourMapper::allocateRGBATableOfSize(int numberOfValues)
{
    mRGBATable = (rgbaPixel*) malloc((numberOfValues + 1) * sizeof(rgbaPixel));
}

rgbaPixel const*& LinearColourMapper::rgbaTable() const
{
    return (rgbaPixel const*&) mRGBATable;
}

//----------------------

GreyscaleColourMapper::GreyscaleColourMapper(int maximumValue, int cycles)
{
    allocateRGBATableOfSize(maximumValue);
    
    for (int i=0; i<maximumValue; i++) {
        rgbaComponent greyValue = (i * cycles * 0xff) / maximumValue;
        rgbaComponent* components = (rgbaComponent*) &mRGBATable[i];
        components[0] = components[1] = components[2] = greyValue;
        components[3] = 0xff;
    }
    
    mRGBATable[maximumValue] = cBlack;
}

//----------------------

HSVColourMapper::HSVColourMapper(int maximumValue, int valuesBeforeRepeat)
{
    allocateRGBATableOfSize(maximumValue);
    
    for (int i=0; i<maximumValue; i++) {
        float normalisedHue = (float) (i % valuesBeforeRepeat) / valuesBeforeRepeat;
        mRGBATable[i] = mHSVConverter.rgbaFromHSV(normalisedHue, 1.0f, 1.0f);
    }
    
    mRGBATable[maximumValue] = cBlack;
}

//----------------------

// http://en.wikipedia.org/wiki/HSL_and_HSV#From_HSV
rgbaPixel HSVToRGBAConverter::rgbaFromHSV(float hue, float saturation, float value)
{
    float chroma = value * saturation;
    float huePeriod = hue * 6.0f;
    float x = chroma * (1.0f - fabsf(fmodf(huePeriod, 2.0f) - 1));  // Second largest component

    float red, green, blue;
    switch ((int) huePeriod) {
        case 0:
            red = chroma;   green = x;      blue = 0.0f;
            break;
        case 1:
            red = x;        green = chroma; blue = 0.0f;
            break;
        case 2:
            red = 0.0f;     green = chroma; blue = x;
            break;
        case 3:
            red = 0.0f;     green = x;      blue = chroma;
            break;
        case 4:
            red = x;        green = 0.0f;   blue = chroma;
            break;
        case 5:
            red = chroma;   green = 0.0f;   blue = x;
            break;
    }
    
    red += value - chroma;
    blue += value - chroma;
    green += value - chroma;
 
    rgbaPixel rgba;
    rgba.components.red = (red * 255.0f);
    rgba.components.green = (rgbaComponent) (green * 255.0f);
    rgba.components.blue = (rgbaComponent) (blue * 255.0f);
    rgba.components.alpha = 0xff;
    
    return rgba;
}
    
