//
//  PixelBufferView.h
//  Flow2D
//
//  Created by Dan Borthwick on 04/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "FlowTypes.h"
#include "Renderable.h"

@interface PixelBufferView : UIView

- (void)addEffect:(Renderable*)effect;

@end
