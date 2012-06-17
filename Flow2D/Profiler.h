//
//  Profiler.h
//  Flow2D
//
//  Created by Dan Borthwick on 17/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Profiler : NSObject

-(id)initWithName:(NSString*)name;

-(void)start;
-(void)finish;

@property NSString* name;
@property uint64_t startTime;

@end
