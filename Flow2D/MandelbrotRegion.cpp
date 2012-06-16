//
//  MandelbrotRegion.cpp
//  Flow2D
//
//  Created by Dan Borthwick on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "MandelbrotRegion.h"

MandelbrotRegion MandelbrotRegion::unitRegion()
{
    MandelbrotRegion region;
    region.left = -1.0f;
    region.right = 1.0f;
    region.bottom = -1.0f;
    region.top = 1.0f;
    
    return region;
}

CGPoint MandelbrotRegion::centre()
{
    return CGPointMake((right - left) / 2.0f, (top - bottom) / 2.0f);
}

void MandelbrotRegion::translate(CGPoint const& translation)
{
    left += translation.x;
    right += translation.x;
    top += translation.y;
    bottom += translation.y;
}

void MandelbrotRegion::scale(float scaleFactor, CGPoint const& centre)
{
    translate(CGPointMake(-centre.x, -centre.y));
    
    left *= scaleFactor;
    right *= scaleFactor;
    top *= scaleFactor;
    bottom *= scaleFactor;
    
    translate(centre);
}
