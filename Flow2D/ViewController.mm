//
//  ViewController.m
//  Flow2D
//
//  Created by Dan Borthwick on 04/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#include "FractalEffect.h"
#import "PixelBufferView.h"
#import "PanController.h"
#import "ZoomController.h"

@interface ViewController ()

@property PanController* mPanController;
@property ZoomController* mZoomController;

@end

@implementation ViewController

@synthesize mPanController;
@synthesize mZoomController;

- (void)viewDidLoad
{
    [super viewDidLoad];

    PixelBufferView* pixelBufferView = (PixelBufferView*) [self view];

    FractalEffect* pEffect = new FractalEffect;
    [pixelBufferView addEffect:pEffect];
    
    mPanController = [[PanController alloc] initWithView:pixelBufferView andEffect:pEffect];
    mZoomController = [[ZoomController alloc] initWithView:pixelBufferView andEffect:pEffect];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
