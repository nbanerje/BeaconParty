    //
//  MasterViewController.m
//  Beacon Party
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "MasterViewController.h"
#import "OMDScreenColorSpec.h"
#import "OMDBeaconPartySchedule.h"
#import "Debug.h"
#import "AppDelegate.h"

@interface MasterViewController ()
@property (strong,nonatomic) OMDBeaconPartySchedule* schedule;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if(!_schedule) {
        _schedule = [[OMDBeaconPartySchedule alloc] initWithJSON:[[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"json"] view:self.view debugTextView:_debugTextView epoch:[NSDate date] uuid:@"BF5094D9-5849-47ED-8FA1-983A748A9586" identifier:@"is.ziggy"];
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.schedule = _schedule;
    }
    
    /*
    _beaconParty = [[OMDBeaconParty alloc] init:@"BF5094D9-5849-47ED-8FA1-983A748A9586" identifier:@"com.omdesignllc.beaconparty" debugTextView:_debugTextView];
    _beaconParty.delegate = self;
    
    _scheduler = [OMDBeaconPartyScheduler scheduler];
    
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Sample" ofType:@"json"];
    NSArray *JSON = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:NSJSONReadingMutableContainers error: &error];
    if(error) {
        DLog(@"%@",[error debugDescription]);
    }
    NSLog([JSON debugDescription]);
    _scheduler.epoch = [NSDate date];
    _scheduler.schedules = JSON;
    _scheduler.view = self.view;
    _scheduler.debugTextView = _debugTextView;
    */
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
