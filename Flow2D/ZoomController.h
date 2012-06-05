//
//  CameraFovPinchController.h
//  CameraQuestion
//
//  Created by Dan Borthwick on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FractalController.h"
#import "MandelbrotRender.h"

@interface ZoomController : FractalController<UIGestureRecognizerDelegate>

-(void)handlePinchEvent:(UIPinchGestureRecognizer*)recognizer;
+(void)scaleRegion:(MandelbrotRegion&)region byScaleFactor:(float)scaleFactor;

@end
