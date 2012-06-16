//
//  PanControllerTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 14/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PanControllerTests.h"

#import "PanController.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

@implementation PanControllerTests

-(void)testGivenAUnitRegion_whenTranslatedByTwoToRight_thenResultIsOneToThreeOnXAxis
{
    MandelbrotRegion region = MandelbrotRegion::unitRegion();
    region.translate(CGPointMake(2.0f, 0.0f));
    
    assertThatFloat(region.left, equalToFloat(1.0f));
    assertThatFloat(region.right, equalToFloat(3.0f));
    assertThatFloat(region.bottom, equalToFloat(-1.0f));
    assertThatFloat(region.top, equalToFloat(1.0f));
}

-(void)testGivenAViewOfWidthTenAndMandelbrotRegionOfWidthTwo_whenScaleFactorIsFound_thenScaleFactorIsOneFifth
{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    MandelbrotRegion region = MandelbrotRegion::unitRegion();
    
    float actualScaleFactor = [PanController scaleFactorFromView:view toMandelbrotRegion:region];

    assertThatFloat(actualScaleFactor, equalToFloat(2.0f / 20.0f));
}
@end
