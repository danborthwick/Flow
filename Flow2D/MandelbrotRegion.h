//
//  MandelbrotRegion.h
//  Flow2D
//
//  Created by Dan Borthwick on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_MandelbrotRegion_h
#define Flow2D_MandelbrotRegion_h

#import <CoreGraphics/CGGeometry.h>

class MandelbrotRegion
{
public:
    float left;
    float right;
    float top;
    float bottom;
    
    CGPoint centre();
    void translate(CGPoint const& translation);
    void scale(float scaleFactor, CGPoint const& centre);
    
    static MandelbrotRegion unitRegion();
};

#endif
