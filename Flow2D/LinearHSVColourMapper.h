//
//  LinearHSVColourMapper.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_LinearHSVColourMapper_h
#define Flow2D_LinearHSVColourMapper_h

#include "Colour.h"

class LinearColourMapper
{
public:
    rgbaPixel const*& rgbaTable() const;
    
protected:
    void allocateRGBATableOfSize(int numberOfValues);
    
    rgbaPixel* mRGBATable;
};

class GreyscaleColourMapper : public LinearColourMapper
{
public:
    GreyscaleColourMapper(int maximumValue, int cycles);
};

class HSVToRGBAConverter
{
public:
    rgbaPixel rgbaFromHSV(float hue, float saturation, float value);
};

class HSVColourMapper : public LinearColourMapper
{
public:
    HSVColourMapper(int maximumValue, int valuesBeforeRepeat);
private:
    HSVToRGBAConverter mHSVConverter;
};

#endif
