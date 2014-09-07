//
//  OMDTorch.h
//  Beacon Party
//
//  Created by Neel Banerjee on 9/6/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMDTorch : NSObject

+ (id)shared;
- (void)startTorching;

@property (strong, nonatomic) NSNumber* frequency;
@property (strong, nonatomic) NSNumber* brightness;
@property (assign, nonatomic) BOOL continueTorch;

@end
