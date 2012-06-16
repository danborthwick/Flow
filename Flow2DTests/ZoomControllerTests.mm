//
//  ZoomControllerTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 06/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoomControllerTests.h"

#import "ZoomController.h"
#import "MandelbrotRegion.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@implementation ZoomControllerTests

-(void)testGivenAUnitRegion_whenZoomedByTwoAboutOrigin_thenResultIsOneByOneRegion
{
    MandelbrotRegion region = MandelbrotRegion::unitRegion();
    CGPoint centre = CGPointMake(0, 0);
    
    region.scale(2.0f, centre);
    
    assertThatFloat(region.left, equalToFloat(-2.0f));
    assertThatFloat(region.right, equalToFloat(2.0f));
    assertThatFloat(region.bottom, equalToFloat(-2.0f));
    assertThatFloat(region.top, equalToFloat(2.0f));
}

-(void)testGivenAUnitRegion_whenZoomedByTwoAboutCorner_thenResultIsOneByOneRegion
{
    MandelbrotRegion region = MandelbrotRegion::unitRegion();
    CGPoint centre = CGPointMake(-1.0f, -1.0f);
    
    region.scale(2.0f, centre);
    
    assertThatFloat(region.left, equalToFloat(-1.0f));
    assertThatFloat(region.right, equalToFloat(3.0f));
    assertThatFloat(region.bottom, equalToFloat(-1.0f));
    assertThatFloat(region.top, equalToFloat(3.0f));
}

@end
