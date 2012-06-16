//
//  SimplePixelBufferProvider.m
//  Flow2D
//
//  Created by Dan Borthwick on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SimplePixelBufferProvider.h"

@interface SimplePixelBufferProvider()
{
    RGBABuffer mBuffer;
}
@end

@implementation SimplePixelBufferProvider

-(id)initWithScreenWidth:(int)screenWidth andScreenHeight:(int)screenHeight
{
    self = [super initWithScreenWidth:screenWidth andScreenHeight:screenHeight];
    if (self) {
        mBuffer.width = screenWidth;
        mBuffer.height = screenHeight;
        mBuffer.buffer = (rgbaPixel*) malloc(screenWidth * screenHeight * sizeof(rgbaPixel));
    }
    return self;
}

-(RGBABuffer const&)buffer
{
    return mBuffer;
}

@end
