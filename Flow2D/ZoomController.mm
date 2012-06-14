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
-(CGPoint)pointInRegion:(MandelbrotRegion const&)region ofPointInView:(CGPoint const&)pointInViewCoordinates;

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
    
    CGPoint centreInViewCoordinates = [recognizer locationInView:[self mView]];
    CGPoint centreInMandelbrotCoordinates = [self pointInRegion:mRegionAtAtStartOfPinch ofPointInView:centreInViewCoordinates];
    
    [ZoomController zoomRegion:newVisibleRegion aboutCentre:centreInMandelbrotCoordinates byZoomFactor:[recognizer scale]];
    
    mEffect->setVisibleRegion(newVisibleRegion);

    [self.mView setNeedsDisplay];
}

-(CGPoint)pointInRegion:(MandelbrotRegion const&)region ofPointInView:(CGPoint const&)pointInViewCoordinates
{
//    NSLog(@"pointInRegion viewX:%.2f viewW:%.2f", pointInViewCoordinates.x, [self mView].bounds.size.width);
    return CGPointMake(
                       region.left + ((pointInViewCoordinates.x / [self mView].bounds.size.width) * (region.right - region.left)),
                       region.bottom + ((pointInViewCoordinates.y / [self mView].bounds.size.height) * (region.top - region.bottom))
                       );
}

                                                         
+(void)zoomRegion:(MandelbrotRegion&)region aboutCentre:(CGPoint&)centre byZoomFactor:(float)zoomFactor
{
    region.left = centre.x + ((region.left - centre.x) / zoomFactor);
    region.right = centre.x + ((region.right - centre.x) / zoomFactor);
    region.top = centre.y + ((region.top - centre.y) / zoomFactor);
    region.bottom = centre.y + ((region.bottom - centre.y) / zoomFactor);
}

@end
