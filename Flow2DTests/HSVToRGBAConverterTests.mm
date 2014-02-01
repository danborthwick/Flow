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
    rgbaPixel rgba = { [rgbaNSNumber intValue] };
    
    if (rgba.components.red != expectedRed)
        return NO;
    if (rgba.components.green != expectedGreen)
        return NO;
    if (rgba.components.blue != expectedBlue)
        return NO;
    if (rgba.components.alpha != expectedAlpha)
        return NO;
    
    return YES;
}

- (void) describeTo:(id<HCDescription>)description
{
    [description appendText:[NSString stringWithFormat:@"RGBA value with components (r:%d, g:%d, b:%d, a:%d)", expectedRed, expectedGreen, expectedBlue, expectedAlpha]];
}

- (void)describeMismatchOf:(id)rgbaNSNumber to:(id<HCDescription>)mismatchDescription
{
    rgbaPixel rgba = { [rgbaNSNumber intValue] };

    if (rgba.components.red != expectedRed) {
        [mismatchDescription appendText:[NSString stringWithFormat:@"red component  was %d, ", rgba.components.red]];
    }
    if (rgba.components.green != expectedGreen) {
        [mismatchDescription appendText:[NSString stringWithFormat:@"green component  was %d, ", rgba.components.green]];
    }
    if (rgba.components.blue != expectedBlue) {
        [mismatchDescription appendText:[NSString stringWithFormat:@"blue component  was %d, ", rgba.components.blue]];
    }
    if (rgba.components.alpha != expectedAlpha) {
        [mismatchDescription appendText:[NSString stringWithFormat:@"alpha component  was %d", rgba.components.alpha]];
    }
}

@end

id<HCMatcher> hasComponents(rgbaComponent red, rgbaComponent green, rgbaComponent blue, rgbaComponent alpha)
{
    return [RGBAMatcher rgbaMatchesR:red g:green b:blue a:alpha];
}