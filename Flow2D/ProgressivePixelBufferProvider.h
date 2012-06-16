//
//  ProgressivePixelBufferProvider.h
//  Flow2D
//
//  Created by Dan Borthwick on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PixelBufferProvider.h"

@interface ProgressivePixelBufferProvider : PixelBufferProvider

-(id)initWithScreenWidth:(int)screenWidth andScreenHeight:(int)screenHeight andMinimumDownsample:(int)minimumDownSample andMaximumDownsample:(int)maximumDownsample;

-(RGBABuffer const&)buffer;
-(void)setDownsamplingToMaximum;
-(void)progressToNextDownsampleLevel;
-(BOOL)hasLowerDownsampleLevel;

@end
