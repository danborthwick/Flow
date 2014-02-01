//
//  HSVToRGBAConverterTests.h
//  Flow2D
//
//  Created by Dan Borthwick on 05/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import <OCHamcrestIOS/HCBaseMatcher.h>
#import <OCHamcrest/HCDescription.h>
#import "Colour.h"

@interface HSVToRGBAConverterTests : SenTestCase

@end

@interface RGBAMatcher : HCBaseMatcher {
@private
    rgbaComponent expectedRed;
    rgbaComponent expectedGreen;
    rgbaComponent expectedBlue;
    rgbaComponent expectedAlpha;
}

+ (id) rgbaMatchesR:(rgbaComponent)r g:(rgbaComponent)g b:(rgbaComponent)b a:(rgbaComponent)a;
- (id) initWithR:(rgbaComponent)r g:(rgbaComponent)g b:(rgbaComponent)b a:(rgbaComponent)a;

@end

OBJC_EXPORT id<HCMatcher> hasComponents(rgbaComponent red, rgbaComponent green, rgbaComponent blue, rgbaComponent alpha);

#define assertThatRGBA(rgbaPixel, expectation) assertThat([NSNumber numberWithInt:rgbaPixel.rgba], expectation)
