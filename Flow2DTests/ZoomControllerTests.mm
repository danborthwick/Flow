//
//  ZoomControllerTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 06/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoomControllerTests.h"

#import "ZoomController.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@implementation ZoomControllerTests

-(void)testGivenAUnitRegion_whenZoomedByTwoAboutOrigin_thenResultIsOneByOneRegion
{
    MandelbrotRegion region = MandelbrotRegion::unitRegion();
    CGPoint centre = CGPointMake(0, 0);
    
    [ZoomController zoomRegion:region aboutCentre:centre byZoomFactor:2.0f];
    
    assertThatFloat(region.left, equalToFloat(-0.5f));
    assertThatFloat(region.right, equalToFloat(0.5f));
    assertThatFloat(region.bottom, equalToFloat(-0.5f));
    assertThatFloat(region.top, equalToFloat(0.5f));
}

-(void)testGivenAUnitRegion_whenZoomedByTwoAboutCorner_thenResultIsOneByOneRegion
{
    MandelbrotRegion region = MandelbrotRegion::unitRegion();
    CGPoint centre = CGPointMake(-1.0f, -1.0f);
    
    [ZoomController zoomRegion:region aboutCentre:centre byZoomFactor:2.0f];
    
    assertThatFloat(region.left, equalToFloat(-1.0f));
    assertThatFloat(region.right, equalToFloat(-0.0f));
    assertThatFloat(region.bottom, equalToFloat(-1.0f));
    assertThatFloat(region.top, equalToFloat(-0.0f));
}

@end
