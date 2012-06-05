//
//  CameraFieldOfViewController.m
//  CameraQuestion
//
//  Created by Dan Borthwick on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ZoomController.h"

#import "FractalEffect.h"

@interface ZoomController() {
@private
    MandelbrotRegion mRegionAtAtStartOfPinch;
}

-(void)setupPinchRecognizerWithView:(UIView*)view;
-(void)handlePinchBeganEvent:(UIPinchGestureRecognizer*)recognizer;
-(void)handlePinchChangedEvent:(UIPinchGestureRecognizer*)recognizer;

@end

@implementation ZoomController

-(id)initWithView:(UIView *)view andEffect:(FractalEffect*)effect
{
    self = [super initWithView:view andEffect:effect];
    if (self)
    {
        [self setupPinchRecognizerWithView:view];
    }
    return self;
}

-(void)setupPinchRecognizerWithView:(UIView*)view
{
    UIPinchGestureRecognizer* pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchEvent:)];
    [pinchRecognizer setDelegate:self];
    [view addGestureRecognizer:pinchRecognizer];

}

-(void)handlePinchEvent:(UIPinchGestureRecognizer*)recognizer
{
    switch ([recognizer state]) {
        case UIGestureRecognizerStateBegan:
            [self handlePinchBeganEvent:recognizer];
            break;
            
        case UIGestureRecognizerStateChanged:
            [self handlePinchChangedEvent:recognizer];
            break;
            
        default:
            break;
    }
}

-(void)handlePinchBeganEvent:(UIPinchGestureRecognizer*)recognizer
{
    mRegionAtAtStartOfPinch = mEffect->visibleRegion();
}

-(void)handlePinchChangedEvent:(UIPinchGestureRecognizer*)recognizer
{
    MandelbrotRegion newVisibleRegion = mRegionAtAtStartOfPinch;
    [ZoomController scaleRegion:newVisibleRegion byScaleFactor:[recognizer scale]];
    mEffect->setVisibleRegion(newVisibleRegion);

    [self.mView setNeedsDisplay];
}

+(void)scaleRegion:(MandelbrotRegion&)region byScaleFactor:(float)scaleFactor;
{
    float centreX = (region.right + region.left) / 2.0;
    float centreY = (region.top + region.bottom) / 2.0;
    
    region.left = centreX + (scaleFactor * (region.left - centreX));
    region.right = centreX + (scaleFactor * (region.right - centreX));
    region.top = centreY + (scaleFactor * (region.top - centreY));
    region.bottom = centreY + (scaleFactor * (region.bottom - centreY));
}

@end
