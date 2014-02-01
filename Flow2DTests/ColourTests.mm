//
//  ColourTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 30/01/2014.
//
//

#import <SenTestingKit/SenTestingKit.h>
#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#include "Colour.h"
#include "HSVToRGBAConverterTests.h"

@interface ColourTests : SenTestCase

@end

@implementation ColourTests

- (void) testGivenARedRGBAValue_thenComponentsCanBeAccessed
{
	assertThatRGBA(cRed, hasComponents(0xff, 0x00, 0x00, 0xff));
}

- (void) testGivenABlueRGBAValue_thenComponentsCanBeAccessed
{
	assertThatRGBA(cBlue, hasComponents(0x00, 0x00, 0xff, 0xff));
}

- (void)testWhenInterpolatingBetweenWhiteAndBlack_thenResultIsGrey
{
	assertThatRGBA(interpolateColour(cWhite, cBlack, 0.5), hasComponents(0x7f, 0x7f, 0x7f, 0xff));
}

@end
