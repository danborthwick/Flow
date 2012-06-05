//
//  HSVToRGBAConverterTests.m
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HSVToRGBAConverterTests.h"

#include "LinearHSVColourMapper.h"

#define HC_SHORTHAND
#import <OCHamcrestIOS/OCHamcrestIOS.h>

#define assertThatRGBA(rgbaPixel, expectation) assertThat([NSNumber numberWithInt:rgbaPixel], expectation)
#define FULL 0xff
#define HALF 0x7f

@implementation HSVToRGBAConverterTests

HSVToRGBAConverter converter;

- (void)testWhenHSVBlackIsConverted_thenRGBABlackIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(0.3, 0.0, 0.0);

    assertThatRGBA(rgba, hasComponents(0, 0, 0, FULL));
}

- (void)testWhenHSVWhiteIsConverted_thenRGBAWhiteIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(0.3, 0.0, 1.0);
    
    assertThatRGBA(rgba, hasComponents(FULL, FULL, FULL, FULL));
}

- (void)testWhenHSVHalfGreyIsConverted_thenRGBAHalfGreyIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(0.3, 0.0, 0.5);
    
    assertThatRGBA(rgba, hasComponents(HALF, HALF, HALF, FULL));
}

- (void)testWhenHSVFullBlueIsConverted_thenRGBAFullBlueIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(2.0/3.0, 1.0, 1.0);
    
    assertThatRGBA(rgba, hasComponents(0, 0, FULL, FULL));
}

- (void)testWhenHSVHalfBlueIsConverted_thenRGBAHalfBlueIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(2.0/3.0, 0.5, 1.0);
    
    assertThatRGBA(rgba, hasComponents(HALF, HALF, FULL, FULL));
}

- (void)testWhenHSVFullRedIsConverted_thenRGBAFullRedIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(0.0, 1.0, 1.0);
    
    assertThatRGBA(rgba, hasComponents(FULL, 00, 00, FULL));
}

- (void)testWhenHSVHalfRedIsConverted_thenRGBAHalfRedIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(0.0, 0.5, 1.0);
    
    assertThatRGBA(rgba, hasComponents(FULL, HALF, HALF, FULL));
}

- (void)testWhenHSVFullGreenIsConverted_thenRGBAFullGreenIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(1.0/3.0, 1.0, 1.0);
    
    assertThatRGBA(rgba, hasComponents(0, FULL, 0, FULL));
}

- (void)testWhenHSVHalfGreenIsConverted_thenRGBAHalfGreenIsReturned
{
    rgbaPixel rgba = converter.rgbaFromHSV(1.0/3.0, 0.5, 1.0);
    
    assertThatRGBA(rgba, hasComponents(HALF, FULL, HALF, FULL));
}

@end


@implementation RGBAMatcher

+ (id) rgbaMatchesR:(rgbaComponent)r g:(rgbaComponent)g b:(rgbaComponent)b a:(rgbaComponent)a
{
    return [[RGBAMatcher alloc] initWithR:r g:g b:b a:a];
}

- (id) initWithR:(rgbaComponent)r g:(rgbaComponent)g b:(rgbaComponent)b a:(rgbaComponent)a
{
    if (self = [super init]) {
        expectedRed = r;
        expectedGreen = g;
        expectedBlue = b;
        expectedAlpha = a;
    }
    return self;
}

- (BOOL) matches:(id)rgbaNSNumber
{
    rgbaPixel rgba = [rgbaNSNumber intValue];
    rgbaComponent* actualComponents = (rgbaComponent*)&rgba;
    
    if (actualComponents[0] != expectedRed)
        return NO;
    if (actualComponents[1] != expectedGreen)
        return NO;
    if (actualComponents[2] != expectedBlue)
        return NO;
    if (actualComponents[3] != expectedAlpha)
        return NO;
    
    return YES;
}

- (void) describeTo:(id<HCDescription>)description
{
    [description appendText:[NSString stringWithFormat:@"RGBA value with components (r:%d, g:%d, b:%d, a:%d)", expectedRed, expectedGreen, expectedBlue, expectedAlpha]];
}

- (void)describeMismatchOf:(id)rgbaNSNumber to:(id<HCDescription>)mismatchDescription
{
    rgbaPixel rgba = [rgbaNSNumber intValue];
    rgbaComponent* actualComponents = (rgbaComponent*)&rgba;

    if (actualComponents[0] != expectedRed) {
        [mismatchDescription appendText:[NSString stringWithFormat:@"red component  was %d, ", actualComponents[0]]];
    }
    if (actualComponents[1] != expectedGreen) {
        [mismatchDescription appendText:[NSString stringWithFormat:@"green component  was %d, ", actualComponents[1]]];
    }
    if (actualComponents[2] != expectedBlue) {
        [mismatchDescription appendText:[NSString stringWithFormat:@"blue component  was %d, ", actualComponents[2]]];
    }
    if (actualComponents[3] != expectedAlpha) {
        [mismatchDescription appendText:[NSString stringWithFormat:@"alpha component  was %d", actualComponents[3]]];
    }
}

@end

id<HCMatcher> hasComponents(rgbaComponent red, rgbaComponent green, rgbaComponent blue, rgbaComponent alpha)
{
    return [RGBAMatcher rgbaMatchesR:red g:green b:blue a:alpha];
}