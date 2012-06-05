//
//  ZoomControllerTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 06/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoomControllerTests.h"

#import "ZoomController.h"
#include "MandelbrotRender.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@implementation ZoomControllerTests

-(void)testGivenAUnitRegion_whenScaledByTwo_thenResultIsTwoByTwoRegion
{
    MandelbrotRegion region;
    region.left = -1.0f;
    region.right = 1.0f;
    region.bottom = -1.0f;
    region.top = 1.0f;
    
    [ZoomController scaleRegion:region byScaleFactor:2.0f];
    
    assertThatFloat(region.left, equalToFloat(-2.0f));
    assertThatFloat(region.right, equalToFloat(2.0f));
    assertThatFloat(region.bottom, equalToFloat(-2.0f));
    assertThatFloat(region.top, equalToFloat(2.0f));
}

@end
