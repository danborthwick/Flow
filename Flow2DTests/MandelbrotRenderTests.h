//
//  MandelbrotRenderTests.h
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#include "MandelbrotRender.h"

typedef struct {
    coord pointX, pointY;
    coord x, y;
    coord xSquared, ySquared;
} tIterateParameters;

@interface MandelbrotRenderTests : SenTestCase

@end
