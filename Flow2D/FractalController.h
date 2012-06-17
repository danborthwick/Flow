//
//  WorldController.h
//  CameraQuestion
//
//  Created by Dan Borthwick on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MandelbrotRegion.h"
#import "PixelBufferView.h"

class FractalEffect;

@interface FractalController : NSObject<UIGestureRecognizerDelegate>
{
    FractalEffect*  mEffect;
}

@property (retain) PixelBufferView* mView;

@property NSMutableDictionary* mStateSelectorMapping;

-(id)initWithView:(PixelBufferView*)view andEffect:(FractalEffect*)effect andRecognizerClass:(Class)recognizerClass;
-(void)mapGestureState:(UIGestureRecognizerState)state toSelector:(SEL)selector;

+(float)scaleFactorFromView:(UIView*)view toMandelbrotRegion:(MandelbrotRegion const&)region;

@end
