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
@property (strong, nonatomic) OMDBeaconPartyScheduler *scheduler;
@property (strong, nonatomic) OMDBeaconParty *beaconParty;
@property (weak,nonatomic) CLBeacon *currentBeacon;

@end

@implementation OMDBeaconPartySchedule

+(instancetype) shared {
    static OMDBeaconPartySchedule *schedule = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        schedule = [[self alloc] init];
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
    
    
    //Download data from latest link
    if(![OMDBeaconPartySchedule reloadData]) {
        fetchURLData(FETCH_URL_STR,self,nil);
    }
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
    [self selectSequenceFromBeacon:_currentBeacon];    
}

-(void) selectSequenceFromBeacon:(CLBeacon*)beacon {
    NSString *uuid = beacon.proximityUUID.UUIDString;
    NSNumber *major = beacon.major;
    NSNumber *minor = beacon.minor;
    
    //Find the schedule sequence that matches this beacon
    NSArray *filteredarray = [_schedule filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(%K == %@ AND %K == %@ AND %K == %@)",@"uuid",uuid,@"major",major,@"minor",minor]];
    
    if(filteredarray.count > 1) {
        DLog(@"Error found %lu objects for beacon should only have one.",(unsigned long)filteredarray.count);
    }
    
    //Assign the correct sequence for the beacon region to the schedule and start the scheduler
    if(filteredarray && filteredarray.count >=1) {
        self.scheduler.beacon = beacon;
        self.scheduler.sequences = filteredarray[0][@"sequence"];
    }
}

#pragma mark OMDBeaconParty Delegate
- (void)updateWithBeacon:(CLBeacon*) beacon {
    _currentBeacon = beacon;
    [self selectSequenceFromBeacon:_currentBeacon];
}

@end
