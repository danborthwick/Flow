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
    CGPoint mCentreOfPinchAtStartOfPinch;
}

-(void)handlePinchBeganEvent:(UIPinchGestureRecognizer*)recognizer;
-(void)handlePinchChangedEvent:(UIPinchGestureRecognizer*)recognizer;
-(CGPoint)pointInRegion:(MandelbrotRegion const&)region ofPointInView:(CGPoint const&)pointInViewCoordinates;

@end

@implementation ZoomController

-(id)initWithView:(PixelBufferView*)view andEffect:(FractalEffect*)effect
{
    self = [super initWithView:view andEffect:effect andRecognizerClass:[UIPinchGestureRecognizer class]];
    if (self)
    {
        [self mapStatesToSelectors];
    }
    return self;
}

-(void)mapStatesToSelectors
{
    [self mapGestureState:UIGestureRecognizerStateBegan toSelector:@selector(handlePinchBeganEvent:)];
    [self mapGestureState:UIGestureRecognizerStateChanged toSelector:@selector(handlePinchChangedEvent:)];
}

-(void)handlePinchBeganEvent:(UIPinchGestureRecognizer*)recognizer
{
    mRegionAtAtStartOfPinch = mEffect->visibleRegion();
    mCentreOfPinchAtStartOfPinch = [recognizer locationInView:[self mView]];
}

-(void)handlePinchChangedEvent:(UIPinchGestureRecognizer*)recognizer
{
    CGPoint centreInViewSpace = [recognizer locationInView:self.mView];
    CGPoint centreInMandelbrotSpace = [self pointInRegion:mRegionAtAtStartOfPinch ofPointInView:centreInViewSpace];
    CGPoint translationInViewSpace = CGPointMake(mCentreOfPinchAtStartOfPinch.x - centreInViewSpace.x, mCentreOfPinchAtStartOfPinch.y - centreInViewSpace.y);
    
    float viewToMandelbrotScaleFactor = [FractalController scaleFactorFromView:self.mView toMandelbrotRegion:mRegionAtAtStartOfPinch];
    CGPoint translationInMandelbrotSpace = CGPointMake(translationInViewSpace.x * viewToMandelbrotScaleFactor, translationInViewSpace.y * viewToMandelbrotScaleFactor);
    
    MandelbrotRegion newVisibleRegion = mRegionAtAtStartOfPinch;
    newVisibleRegion.scale(1.0f / recognizer.scale, centreInMandelbrotSpace);
    newVisibleRegion.translate(translationInMandelbrotSpace);

    mEffect->setVisibleRegion(newVisibleRegion);

    [self.mView setNeedsDisplay];
}

-(CGPoint)pointInRegion:(MandelbrotRegion const&)region ofPointInView:(CGPoint const&)pointInViewCoordinates
{
//    NSLog(@"pointInRegion viewX:%.2f viewW:%.2f", pointInViewCoordinates.x, [self mView].bounds.size.width);
    return CGPointMake(
                       region.left + ((pointInViewCoordinates.x / [self mView].bounds.size.width) * (region.right - region.left)),
                       region.top + ((pointInViewCoordinates.y / [self mView].bounds.size.height) * (region.bottom - region.top))
                       );
}

@end
