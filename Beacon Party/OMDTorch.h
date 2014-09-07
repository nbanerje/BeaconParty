//
//  OMDTorch.h
//  Beacon Party
//
//  Created by Neel Banerjee on 9/6/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define MAX_TWINKLE_FREQUENCY 50.0

/**
 * Torch Modes
 */
typedef enum {
    OMDTorchModeFlash,
    OMDTorchModeTwinkle
} OMDTorchMode;

@interface OMDTorch : NSObject


+ (id)shared;
- (void)startTorching:(OMDTorchMode) mode;

@property (strong, nonatomic) NSNumber* frequency;
@property (strong, nonatomic) NSNumber* brightness;
@property (assign, nonatomic) BOOL continueTorch;
@property (weak, nonatomic) CLBeacon* beacon;
@property (strong, nonatomic) NSNumber* maxFrequency;
@property (strong, nonatomic) NSNumber* offset;


@end
