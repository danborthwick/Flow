//
//  WorldController.m
//  CameraQuestion
//
//  Created by Dan Borthwick on 26/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FractalController.h"

#import <objc/message.h>

@interface FractalController()
-(void)handleEvent:(UIGestureRecognizer*)recognizer;
@end

@implementation FractalController

@synthesize mView;
@synthesize mStateSelectorMapping;

-(id)initWithView:(PixelBufferView*)view andEffect:(FractalEffect*)effect andRecognizerClass:(Class)recognizerClass
{
    self = [super init];
    if (self)
    {
        self.mView = view;
        mEffect = effect;
        mStateSelectorMapping = [NSMutableDictionary dictionary];
        [self setupRecognizerForClass:recognizerClass withView:view];
    }
    return self;
}

-(void)setupRecognizerForClass:(Class)recognizerClass withView:(UIView*)view
{
    UIGestureRecognizer* recognizer = (UIGestureRecognizer*) [[recognizerClass alloc] initWithTarget:self action:@selector(handleEvent:)];
    [recognizer setDelegate:self];
    [view addGestureRecognizer:recognizer];
}

-(void)mapGestureState:(UIGestureRecognizerState)state toSelector:(SEL)selector
{
    [mStateSelectorMapping setValue:NSStringFromSelector(selector) forKey:[NSString stringWithFormat:@"%d", state]];
}

-(SEL)selectorOrNilForGestureState:(UIGestureRecognizerState)state
{
    return NSSelectorFromString([mStateSelectorMapping valueForKey:[NSString stringWithFormat:@"%d", state]]);
}

-(void)handleEvent:(UIGestureRecognizer*)recognizer
{
    SEL selector = [self selectorOrNilForGestureState:[recognizer state]];
    
    if ([self respondsToSelector:selector]) {
        objc_msgSend(self, selector, recognizer);
    }
}

+(float)scaleFactorFromView:(UIView*)view toMandelbrotRegion:(MandelbrotRegion const&)region
{
    float regionWidth = region.right - region.left;
    float viewPixelWidth = view.frame.size.width * 2;
    
    return regionWidth / viewPixelWidth;
}

@end
