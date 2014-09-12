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


+ (instancetype)shared;
- (void)startTorching:(OMDTorchMode) mode;

@property (strong, atomic) NSNumber* frequency;
@property (strong, atomic) NSNumber* brightness;
@property (assign, atomic) BOOL continueTorch;
@property (strong, atomic) NSNumber* delay;

@property (weak, nonatomic) CLBeacon* beacon;
@property (strong, atomic) NSNumber* maxFrequency;
@property (strong, atomic) NSNumber* offset;
@property (assign, atomic) BOOL inverse;

@end
