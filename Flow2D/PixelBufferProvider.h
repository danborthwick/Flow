//
//  PixelBufferProvider.h
//  Flow2D
//
//  Created by Dan Borthwick on 16/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGBABuffer.h"

@interface PixelBufferProvider : NSObject

@property (readonly) int screenWidth;
@property (readonly) int screenHeight;

-(id)initWithScreenWidth:(int)screenWidth andScreenHeight:(int)screenHeight;

-(RGBABuffer const&)buffer;

@end
