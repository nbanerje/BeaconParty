//
//  OMDBeaconPartySchedule.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/4/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//
#import "Debug.h"
#import "OMDBeaconPartySchedule.h"

@interface OMDBeaconPartySchedule()
@property (strong, nonatomic) OMDBeaconPartyScheduler *scheduler;
@property (strong, nonatomic) OMDBeaconParty *beaconParty;
@property (weak,nonatomic) UITextView *debugTextView;
@property (weak,nonatomic) CLBeacon *currentBeacon;

@end

@implementation OMDBeaconPartySchedule

- (instancetype)initWithJSON:(NSString*)path view:(UIView*)view debugTextView:(UITextView*)debugTextView epoch:(NSDate*)epoch uuid:(NSString*)uuid identifier:(NSString*)identifier {

    self = [super init];
    if (self) {
        
        _debugTextView = debugTextView;
        
        //Load JSON base schedule
        NSError *error = nil;
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"json"];
        NSArray *json = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error: &error];
        if(error) {
            DLog(@"%@",[error debugDescription]);
        }
        DLog(@"JSON Loaded: %@",[json debugDescription]);
        
        _schedule = json;
        
        //Setup Beacon Region Monitoring
        _beaconParty = [[OMDBeaconParty alloc] init:uuid identifier:identifier debugTextView:debugTextView];
        _beaconParty.delegate = self;
        
        _scheduler = [OMDBeaconPartyScheduler scheduler]; 
        _scheduler.epoch = epoch;
        _scheduler.view = view;
        _scheduler.debugTextView = _debugTextView;

    }
    return self;
}

-(void) loadScheduleFromJsonData:(NSData*)data {
    //Load JSON base schedule
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    if(error) {
        DLog(@"%@",[error debugDescription]);
    }
    DLog(@"JSON Loaded: %@",[json debugDescription]);
    
    self.schedule = json;

}

-(void) setSchedule:(NSMutableArray*)schedule {
    _schedule = schedule;
    [self selectSequenceFromBeacon:_currentBeacon];
    _scheduler.continueMainLoop = YES;
    [_scheduler startLoop];
    
}

-(void) selectSequenceFromBeacon:(CLBeacon*)beacon {
    NSString *uuid = beacon.proximityUUID.UUIDString;
    NSNumber *major = beacon.major;
    NSNumber *minor = beacon.minor;
    
    //Find the schedule sequence that matches this beacon
    NSArray *filteredarray = [_schedule filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K == %@ AND %K == %@ AND %K == %@)",@"uuid",uuid,@"major",major,@"minor",minor]];
    if(filteredarray.count > 1) {
        DLog(@"Error found %d objects for beacon should only have one.",filteredarray.count);
    }
    
    //Assign the correct sequence for the beacon region to the schedule and start the scheduler
    if(filteredarray && filteredarray.count >=1) {
        //self.scheduler.sequences = [NSMutableArray arrayWithArray:filteredarray[0][@"sequence"]];
        self.scheduler.sequences = filteredarray[0][@"sequence"];
    }
}

#pragma mark OMDBeaconParty Delegate
- (void)updateWithBeacon:(CLBeacon*) beacon {
    _currentBeacon = beacon;
    [self selectSequenceFromBeacon:_currentBeacon];
}

@end
