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
    });
    return shared;
}

- (void)startTorching {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        LARSTorch *torch = [LARSTorch sharedTorch];
        while(_continueTorch) {
            float period = 1.0/self.frequency.floatValue;
            if(self.brightness) {
                [torch setTorchOnWithLevel:self.brightness.floatValue];
            } else {
                [torch setTorchState:LARSTorchStateOn];
            }
            [NSThread sleepForTimeInterval:period/2.0];
            [torch setTorchState:LARSTorchStateOff];
            [NSThread sleepForTimeInterval:period/2.0];
        }
        
    });
}

@end
