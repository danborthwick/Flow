//
//  MandelbrotIterateValuesMatcher.m
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MandelbrotIterateValuesMatcher.h"

@implementation NSIterateValues
@synthesize values;

+(id)from:(tIterateParameters const&)values
{
    NSIterateValues* nsValues = [[NSIterateValues alloc] init];
    nsValues.values = values;
    return nsValues;
}

@end


@implementation MandelbrotIterateValuesMatcher

@synthesize expectedValues;

+ (id) matchesValues:(tIterateParameters const&)expectedValues
{
    return [[MandelbrotIterateValuesMatcher alloc] initWithExpectedValues:expectedValues];
}

- (id) initWithExpectedValues:(tIterateParameters const&)theExpectedValues
{
    self = [super init];
    if (self) {
        expectedValues = theExpectedValues;
    }
    return self;
}

- (BOOL) matches:(id)actualNSValues
{
    tIterateParameters actual = ((NSIterateValues*)actualNSValues).values;
    
    return 
       (actual.x == expectedValues.x)
    && (actual.y == expectedValues.y)
    && (actual.xSquared == expectedValues.xSquared)
    && (actual.ySquared == expectedValues.ySquared)
    && (actual.pointX == expectedValues.pointX)
    && (actual.pointY == expectedValues.pointY);
}

-(void) describeValue:(tIterateParameters const&)valueToDescribe byComparing:(tIterateParameters const&)actual toDescription:(id<HCDescription>)description
{
    if (actual.x != expectedValues.x) {
        [self appendMessageWithDisplay:@"x" value:valueToDescribe.x toDescription:description];
    }
    if (actual.y != expectedValues.y) {
        [self appendMessageWithDisplay:@"y" value:valueToDescribe.y toDescription:description];
    }
    if (actual.xSquared != expectedValues.xSquared) {
        [self appendMessageWithDisplay:@"xSquared" value:valueToDescribe.xSquared toDescription:description];
    }
    if (actual.ySquared != expectedValues.ySquared) {
        [self appendMessageWithDisplay:@"ySquared" value:valueToDescribe.ySquared toDescription:description];
    }
    if (actual.pointX != expectedValues.pointX) {
        [self appendMessageWithDisplay:@"pointX" value:valueToDescribe.pointY toDescription:description];
    }
    if (actual.pointY != expectedValues.pointY) {
        [self appendMessageWithDisplay:@"pointY" value:valueToDescribe.pointY toDescription:description];
    }   
}

-(void) describeTo:(id<HCDescription>)description
{
    [description appendText:[NSString stringWithFormat:
                             @"iterate values with x:%.3f, y:%.3f, xSquared:%.3f, ySquared:%.3f, pointX:%.3f, pointY:%.3f", 
                             expectedValues.x, expectedValues.y, expectedValues.xSquared, expectedValues.ySquared, expectedValues.pointX, expectedValues.pointY]];
}
 
-(void)appendMessageWithDisplay:(NSString*)display value:(coord)value toDescription:(id<HCDescription>)description
{
    [description appendText:[NSString stringWithFormat:@" %@=%.3f", display, value]];
}

- (void)describeMismatchOf:(id)actualNSValues to:(id<HCDescription>)mismatchDescription
{
    tIterateParameters actual = ((NSIterateValues*)actualNSValues).values;
    
    [mismatchDescription appendText:@"actual "];
    [self describeValue:actual byComparing:actual toDescription:mismatchDescription];
}

@end

id<HCMatcher> equalToValues(tIterateParameters const& expected)
{
    return [MandelbrotIterateValuesMatcher matchesValues:expected];
}
