//
//  MandelbrotIterateValuesMatcher.h
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCHamcrestIOS/HCBaseMatcher.h>
#import <OCHamcrest/HCDescription.h>

#import "MandelbrotRenderTests.h"

@interface NSIterateValues : NSObject
@property tIterateParameters values;

+(id)from:(tIterateParameters const&)values;

@end

@interface MandelbrotIterateValuesMatcher : HCBaseMatcher

+ (id) matchesValues:(tIterateParameters const&)expectedValues;
- (id) initWithExpectedValues:(tIterateParameters const&)expectedValues;

@property tIterateParameters expectedValues;

@end

OBJC_EXPORT id<HCMatcher> equalToValues(tIterateParameters const& actualValues);

#define assertThatValues(actual, expected) assertThat([NSIterateValues from:actual], expected)