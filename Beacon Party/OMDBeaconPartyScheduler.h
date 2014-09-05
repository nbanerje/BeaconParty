//
//  OMDBeaconPartySchedule.h
//  Beacon Party
//
//  Created by Neel Banerjee on 8/29/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <Foundation/Foundation.h>
/** Class to represent the Shceduler singleton
 */
@interface OMDBeaconPartyScheduler : NSObject <UIWebViewDelegate>

/**
 View to which all effects are applied
 */
@property (weak, nonatomic) UIView *view;

/**
 This text view can be used to write debug info to a text view.
 All write to the view are on the main thread.
 */
@property (strong, nonatomic) UITextView *debugTextView;

/**
 Set the starting point for all methods to be compared against. 
 You could set this to be UNIX epoch and then use time since 
 1970 as your offsets. There is no concept of timezones in this approch.
 */
@property (strong, atomic) NSDate *epoch;

/**
 This array is used to hold the sequence spec array of dictionary 
 objects which contain a time offset from the epoch and an action spec.
 */
@property (strong, atomic) NSArray *sequences;

/**
 This value can be used to stop the scheduler. If you stop the scheduler you
 will need to restart the scheduler with the startLoop method after setting
 continueMainLoop = YES;
 */
@property (assign, atomic) BOOL continueMainLoop;

@property (assign, atomic) BOOL continueTorch;

/**
 Start the loop scheduler. This is started automatically by instantiating 
 the scheduler singleton.
 */
- (void) startLoop;

/**
 The scheduler singleton. Use this to start the scheduler.
 */
+ (id)scheduler;



@end
