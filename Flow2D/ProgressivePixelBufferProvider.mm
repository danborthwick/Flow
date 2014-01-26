//
//  ProgressivePixelBufferProvider.m
//  Flow2D
//
//  Created by Dan Borthwick on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProgressivePixelBufferProvider.h"

@interface ProgressivePixelBufferProvider()
{
    int mMinimumDownsampleLevel;
    int mMaximumDownsampleLevel;
    int mCurrentDownsampleLevel;
    RGBABuffer* mBuffers;
}

-(void)createBuffers;
-(void)setupBuffer:(RGBABuffer&)buffer withMemory:(rgbaPixel*)pixelBuffer forLevel:(int)level;

@end

@implementation ProgressivePixelBufferProvider

-(id)initWithScreenWidth:(int)screenWidth andScreenHeight:(int)screenHeight andMinimumDownsample:(int)minimumDownSample andMaximumDownsample:(int)maximumDownsample
{
    self = [super initWithScreenWidth:screenWidth andScreenHeight:screenHeight];
    if (self) {
        mMinimumDownsampleLevel = minimumDownSample;
        mMaximumDownsampleLevel = maximumDownsample;
        mCurrentDownsampleLevel = maximumDownsample;
        
        [self createBuffers];
    }
    return self;
}

-(void) createBuffers
{
    mBuffers = new RGBABuffer[mMaximumDownsampleLevel+1];
    
    for (int level=mMinimumDownsampleLevel; level<=mMaximumDownsampleLevel; level++) {
        rgbaPixel* pixelBuffer = (level == mMinimumDownsampleLevel) ? NULL : mBuffers[level-1].buffer;
        [self setupBuffer:mBuffers[level] withMemory:pixelBuffer forLevel:level];
    }
}

-(void)setupBuffer:(RGBABuffer&)buffer withMemory:(rgbaPixel*)pixelBuffer forLevel:(int)level
{
    int scaleFactor = 1 << (level - 1);
    buffer.width = self.screenWidth / scaleFactor;
    buffer.height = self.screenHeight / scaleFactor;
    
    if (pixelBuffer == NULL) {
        pixelBuffer = (rgbaPixel*) malloc(buffer.width * buffer.height * sizeof(rgbaPixel));
    }
    
    buffer.buffer = pixelBuffer;
}


-(RGBABuffer const&)buffer
{
    return mBuffers[mCurrentDownsampleLevel];
}

-(void)setDownsamplingToMaximum
{
    mCurrentDownsampleLevel = mMaximumDownsampleLevel;
}

-(void)progressToNextDownsampleLevel
{
    if ([self hasLowerDownsampleLevel]) {
        mCurrentDownsampleLevel--;
    }
}

-(BOOL)hasLowerDownsampleLevel
{
    return (mCurrentDownsampleLevel > mMinimumDownsampleLevel);
}

@end
