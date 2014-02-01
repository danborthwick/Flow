//
//  FlowTypes.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_FlowTypes_h
#define Flow2D_FlowTypes_h

typedef unsigned char rgbaComponent;

struct rgbaComponents {
	rgbaComponent red;
	rgbaComponent green;
	rgbaComponent blue;
	rgbaComponent alpha;
};

typedef union {
	unsigned int rgba;
	rgbaComponents components;
} rgbaPixel;

const rgbaPixel cBlack = { 0xff000000 };
const rgbaPixel cWhite = { 0xffffffff };
const rgbaPixel cGrey = { 0xff808080 };
const rgbaPixel cRed = { 0xff0000ff };
const rgbaPixel cBlue = { 0xffff0000 };

rgbaPixel interpolateColour(rgbaPixel colourOne, rgbaPixel colourTwo, float interpolationFactor);

#endif
