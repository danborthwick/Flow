//
//  ZoomController.h
//  Flow2D
//
//  Created by Dan Borthwick on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FractalController.h"
#import "MandelbrotRender.h"

@interface ZoomController : FractalController

-(id)initWithView:(PixelBufferView*)view andEffect:(FractalEffect*)effect;

@end
