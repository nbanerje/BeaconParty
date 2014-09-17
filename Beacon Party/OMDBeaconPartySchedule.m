//
//  OMDBeaconPartySchedule.m
//  Beacon Party
//
//  Created by Neel Banerjee on 9/4/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//
#import "Debug.h"
#import "OMDBeaconPartySchedule.h"
#import "AppDelegate.h" //To grab block to update schedule file

@interface OMDBeaconPartySchedule()
@property (strong, nonatomic) OMDBeaconParty *beaconParty;
@property (strong,nonatomic) CLBeacon *currentBeacon;

@end

@implementation OMDBeaconPartySchedule

+(instancetype) shared {
    static OMDBeaconPartySchedule *schedule = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        schedule = [[self alloc] init];
        schedule.forceClearingExecuted = NO;
#ifdef DEBUG_EPOCH
        [schedule loadScheduleFromJsonData:[NSData dataWithContentsOfFile:[[[NSBundle mainBundle] resourcePath]
                                                                           stringByAppendingPathComponent:@"Sample.json"]]];
#endif
    });
    return schedule;
}



+(void) saveData:(NSData*)data {
    //Now save data to disk.
    NSString *filePath = ((NSURL*)[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]).path;
    filePath = [filePath stringByAppendingPathComponent:@"schedule.json"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       BOOL saved =  [[NSFileManager defaultManager] createFileAtPath:filePath
                                                contents:data
                                              attributes:nil];
        NSLog(@"Updated schedule.json %hhd",saved);
    });
    
}

+(BOOL) reloadData {
    //Now save data to disk.
    NSString *filePath = ((NSURL*)[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]).path;
    filePath = [filePath stringByAppendingPathComponent:@"schedule.json"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if(fileExists) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *restoredData =  [[NSFileManager defaultManager] contentsAtPath:filePath];
            if(restoredData) {
                [[OMDBeaconPartySchedule shared] loadScheduleFromJsonData:restoredData];
            }
            
        });
        return YES;
    }
    else {
        return NO;
    }
    
}

- (void) setEpoch:(NSDate*)epoch uuid:(NSString*)uuid identifier:(NSString*)identifier {

    //Setup Beacon Region Monitoring
    _beaconParty = [[OMDBeaconParty alloc] init:uuid identifier:identifier];
    _beaconParty.delegate = self;

    _scheduler = [OMDBeaconPartyScheduler scheduler];
    _scheduler.epoch = epoch;
    
#ifdef DEBUG_EPOCH
    _scheduler.epoch = [NSDate dateWithTimeIntervalSinceNow:0];
#endif
    _scheduler.debugTextView = _debugTextView;
    
}

-(void) setView:(UIView *)view {
    _view = view;
    _scheduler.view = _view;
    
    
}

-(void) setDebugTextView:(UITextView*)view {
    _debugTextView = view;
    _scheduler.debugTextView = _debugTextView;
}
-(void) loadScheduleFromJsonData:(NSData*)data {
    //Load JSON base schedule and save it in the Document directory
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
    //Coerce sequence to load even if we haven't change our minor value.
    [self selectSequenceFromBeacon:_currentBeacon isNewMinorValue:YES];
}

-(void) selectSequenceFromBeacon:(CLBeacon*)beacon isNewMinorValue:(BOOL)isNewMinorValue {
    NSString *uuid = beacon.proximityUUID.UUIDString;
    NSNumber *major = beacon.major;
    NSNumber *minor = beacon.minor;
    
    if(isNewMinorValue) {
        //Find the schedule sequence that matches this beacon
        NSMutableArray *filteredarray = [NSMutableArray arrayWithArray:[_schedule filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K == %@ AND %K == %@ AND %K == %@)",@"uuid",uuid,@"major",major,@"minor",minor]]];
        
        if(filteredarray.count > 1) {
            DLog(@"Error found %lu objects for beacon should only have one.",(unsigned long)filteredarray.count);
        }
        
        //Assign the correct sequence for the beacon region to the schedule and start the scheduler
        if(filteredarray && filteredarray.count >=1) {
            for (NSMutableDictionary *action in filteredarray[0][@"sequence"]) {
                action[@"executed"] = [NSNumber numberWithInt:0];
            }
            self.scheduler.beacon = beacon;
            self.scheduler.sequences = filteredarray[0][@"sequence"];
        }
    } else {
        self.scheduler.beacon = beacon;
    }
}

- (void) test {
    self.scheduler.sequences = [NSMutableArray
                                arrayWithArray:@[
    [NSMutableDictionary dictionaryWithDictionary:@{@"time":@([[NSDate date] timeIntervalSince1970]),@"action":@"particle",@"executed":@(0),@"r1":@(1),@"g1":@(0.75),@"b1":@(0),@"a1":@(1)}],
    [NSMutableDictionary dictionaryWithDictionary:@{@"time":@([[NSDate date] timeIntervalSince1970]+5),@"action":@"flash",@"executed":@(0)}],
   
    [NSMutableDictionary dictionaryWithDictionary:@{@"time":@([[NSDate date] timeIntervalSince1970]+10),@"action":@"stop-particle",@"executed":@(0)}]
    
    ]
                                ];
    
//
    
     //[NSMutableDictionary dictionaryWithDictionary:@{@"time":@([[NSDate date] timeIntervalSince1970]+20),@"action":@"particle",@"executed":@(0)}],
}

#pragma mark OMDBeaconParty Delegate
- (void)updateWithBeacon:(CLBeacon*) beacon {
    BOOL isNewMinorValue = NO;
    if(_currentBeacon == nil || _currentBeacon.minor != beacon.minor) {
        isNewMinorValue = YES;
        [_scheduler clearEffects];
    }
    _currentBeacon = beacon;
    
    [self selectSequenceFromBeacon:_currentBeacon isNewMinorValue:isNewMinorValue ||_forceClearingExecuted];
}

@end
