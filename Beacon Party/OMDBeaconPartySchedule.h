//
//  OMDBeaconPartySchedule.h
//  Beacon Party
//
//  Created by Neel Banerjee on 9/4/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMDBeaconParty.h"
#import "OMDBeaconPartyScheduler.h"

@interface OMDBeaconPartySchedule : NSObject <OMDBeaconPartyDelegate>

+(instancetype) shared;
+(void) saveData:(NSData*)data;
+(void) reloadData;

-(void) setEpoch:(NSDate*)epoch uuid:(NSString*)uuid identifier:(NSString*)identifier;

-(void) loadScheduleFromJsonData:(NSData*)data;

/** Array that hold the current schedule for the event.
    Initially this gets loaded from the Sample.json file, 
    but you can overwrite the array entirely to set a new
    schedule.
 */
@property (strong, nonatomic) NSArray *schedule;
@property (weak,nonatomic) UITextView *debugTextView;
@property (weak,nonatomic) UIView *view;

@end
