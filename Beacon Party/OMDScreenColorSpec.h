//
//  OMDScreenColorSpec.h
//  Beacon Party
//
//  Created by Neel Banerjee on 9/2/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Debug.h"

@interface OMDScreenColorSpec : NSObject

@property (weak, nonatomic) UITextView *debugTextView;

/** view to which colors are applied to the background.
 to blink at duty cycle is alway 50%
 */
@property (weak, nonatomic) UIView *view;

/** used to define the frequency in which 
 to blink at duty cycle is alway 50%
 */
@property (assign, nonatomic) float frequency;

@property (readonly, nonatomic) const NSString *action;

@property (assign, nonatomic) NSTimeInterval delay;

@property (assign, nonatomic) CGFloat brightness;

- (instancetype)initWithR1:(NSNumber*)r1 g1:(NSNumber*)g1 b1:(NSNumber*)b1 a1:(NSNumber*)a1
                        r2:(NSNumber*)r2 g2:(NSNumber*)g2 b2:(NSNumber*)b2 a2:(NSNumber*)a2;

- (instancetype)initWithColor1:(UIColor*)color1
                        color2:(UIColor*)color2;

- (void(^)(void)) block;
- (void(^)(void)) rainbowBlock;

- (void(^)(void)) stopBlock;



@end
