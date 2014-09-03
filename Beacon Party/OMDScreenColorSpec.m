//
//  OMDScreenColorSpec.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/2/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "OMDScreenColorSpec.h"

static const NSString* BEACON_COLOR_ACTION = @"color";

@interface OMDScreenColorSpec()

/** used to define the first color to blink
 */
@property (strong, nonatomic) UIColor *color1;

/** used to define the second color to blink
 */
@property (strong, nonatomic) UIColor *color2;


@end

@implementation OMDScreenColorSpec

- (instancetype)initWithR1:(NSNumber*)r1 g1:(NSNumber*)g1 b1:(NSNumber*)b1 a1:(NSNumber*)a1
                        r2:(NSNumber*)r2 g2:(NSNumber*)g2 b2:(NSNumber*)b2 a2:(NSNumber*)a2
{
    self = [super init];
    if (self) {
        _action = BEACON_COLOR_ACTION;
        _color1 = [UIColor colorWithRed:r1.floatValue green:g1.floatValue blue:b1.floatValue alpha:a1.floatValue];
        _color2 = [UIColor colorWithRed:r2.floatValue green:g2.floatValue blue:b2.floatValue alpha:a2.floatValue];
        _frequency = 1.0f;
        _delay = 0.0f;
    }
    return self;
}

- (instancetype)initWithColor1:(UIColor*)color1
                        color2:(UIColor*)color2
{
    self = [super init];
    if (self) {
        _action = BEACON_COLOR_ACTION;
        _color1 = color1;
        _color2 = color2;
        _frequency = 1.0f;
        _delay = 0.0f;
    }
    return self;
}

- (void(^)(void)) block {
    void(^block)(void);
    block = ^{
        float period = 1.0/_frequency;
        float halfCyclePeriod = period / 2.0;
        _view.backgroundColor = _color1;
        [UIView animateKeyframesWithDuration:period delay:_delay options:UIViewKeyframeAnimationOptionAutoreverse|
         UIViewKeyframeAnimationOptionRepeat animations:^{
             [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:halfCyclePeriod animations:^{
                 _view.backgroundColor = _color1;
             }];
             [UIView addKeyframeWithRelativeStartTime:halfCyclePeriod relativeDuration:period animations:^{
                 _view.backgroundColor = _color2;
             }];
             
         } completion:nil];
    };
    return block;
}

- (void(^)(void)) stopBlock {
    void(^block)(void);
    block = ^{
        [_view.layer removeAllAnimations];
        _view.backgroundColor = _color1;
    };
    return block;
}


@end
