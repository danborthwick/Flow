//
//  PixelBufferProvider.m
//  Flow2D
//
//  Created by Dan Borthwick on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PixelBufferProvider.h"

@implementation PixelBufferProvider

@synthesize screenWidth;
@synthesize screenHeight;

-(id)initWithScreenWidth:(int)theScreenWidth andScreenHeight:(int)theScreenHeight
{
    self = [super init];
    if (self) {
        screenWidth = theScreenWidth;
        screenHeight = theScreenHeight;
    }
    return self;
}

-(RGBABuffer const&)buffer
{
    [self doesNotRecognizeSelector:_cmd];
    return *new RGBABuffer;
}

@end
