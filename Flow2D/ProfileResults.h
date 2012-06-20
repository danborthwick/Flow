//
//  ProfileResults.h
//  Flow2D
//
//  Created by Dan Borthwick on 17/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/*

 Float:     580ms
 Double:    607ms
 store xSquared:    594ms
 fix iteration return type: 589ms
 local scope only: no effect
 no xTemp: no effect
 ++iterations: 578ms
 iterations--: 581ms
 do while: 571ms
 Compiler optimisations to 'fastest smallest': 240ms

 MaxIterations 1024:    3995ms
 return immediately:    46ms
 First working assembler inner loop: 428ms

 */