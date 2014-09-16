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
@property (weak,nonatomic) OMDBeaconPartySchedule* schedule;
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
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        appDelegate.schedule.view = self.pushEffects;
        self.pushEffects.hidden = YES;
#ifdef DEBUG
        _debugTextView.hidden = NO;
        appDelegate.schedule.debugTextView = _debugTextView;
#endif
        [appDelegate.schedule test];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
