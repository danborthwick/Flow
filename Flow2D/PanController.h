//
//  PanController.h
//  Flow2D
//
//  Created by Dan Borthwick on 10/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Flow2D_PanController_h
#define Flow2D_PanController_h

#import <Foundation/Foundation.h>

#import "FractalController.h"
#import "MandelbrotRender.h"

@interface PanController : FractalController

-(id)initWithView:(PixelBufferView*)view andEffect:(FractalEffect*)effect;

@end


#endif
