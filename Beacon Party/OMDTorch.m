//
//  OMDTorch.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/6/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "OMDTorch.h"
#import "LARSTorch.h"
@implementation OMDTorch
+ (id)shared {
    static OMDTorch *shared = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        shared.continueTorch = NO;
        shared.maxFrequency = [NSNumber numberWithFloat:MAX_TWINKLE_FREQUENCY];
        shared.offset = 0;
        shared.inverse = NO;
    });
    return shared;
}

- (void)startTorching:(OMDTorchMode) mode {
    if(!_continueTorch) {
        _continueTorch = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            LARSTorch *torch = [LARSTorch sharedTorch];
            while(_continueTorch) {
                if(_beacon && mode == OMDTorchModeTwinkle) {
                    double distance = self.beacon.accuracy;
                    float frequency = 0.0;
                    if(distance>=0.0){
                        if(distance == 0) {
                            if(_inverse) frequency = _maxFrequency.floatValue;
                            else frequency = 0.0;
                        }
                        else {
                            if(_inverse) frequency = 1.0/distance * _maxFrequency.floatValue + _offset.floatValue;
                            else frequency = distance * _maxFrequency.floatValue + _offset.floatValue;
                        }
                        _frequency = [NSNumber numberWithFloat:frequency];
                        _brightness = [NSNumber numberWithFloat:1.0];
                    }
                }
                
                float period = 1.0/_frequency.floatValue;
                if(_brightness) {
                    [torch setTorchOnWithLevel:_brightness.floatValue];
                } else {
                    [torch setTorchState:LARSTorchStateOn];
                }
                [NSThread sleepForTimeInterval:period/2.0];
                [torch setTorchState:LARSTorchStateOff];
                [NSThread sleepForTimeInterval:period/2.0];
            }
            
        });
    }
}

@end
