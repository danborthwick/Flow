//
//  IterationsASM.h
//  Flow2D
//
//  Created by Dan Borthwick on 18/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


/*

 vorr	d20, d17, d17
 movs	r0, #0
 Ltmp58:
 vmov	d16, r1, r2
 Ltmp59:
 LBB4_1:
 .loc	1 43 5
 vmul.f64	d21, d17, d17       // xsquared = x*x
 Ltmp60:
 .loc	1 42 5
 vmul.f64	d22, d20, d20       //ysquared = y*y
 Ltmp61:
 .loc	1 67 5
 vadd.f64	d23, d22, d21       // while xsquared+ysquared<4
 vcmpe.f64	d23, d19
 vmrs	apsr_nzcv, fpscr
 Ltmp62:
 .loc	1 70 5
 it	pl
 bxpl	lr
 Ltmp63:
 .loc	1 45 5
 vadd.f64	d23, d20, d20       // d23 = 2*y
 Ltmp64:
 .loc	1 67 5
 adds	r0, #1                  // increments++
 Ltmp65:
 cmp	r0, #128                // while(increments<128)
 .loc	1 45 5
 Ltmp66:
 vmul.f64	d17, d23, d17       // y=2*x*y
 .loc	1 46 5
 vsub.f64	d20, d22, d21       // x = ysquared - xsquared
 vadd.f64	d20, d20, d16       // x = ysquared - xsquared + pointx
 Ltmp67:
 .loc	1 45 5
 vadd.f64	d17, d17, d18       // y = 2*x*y + pointy
 Ltmp68:
 blt	LBB4_1
 Ltmp69:
 .loc	1 70 5
 bx	lr
 Ltmp70:
 .align	2

*/