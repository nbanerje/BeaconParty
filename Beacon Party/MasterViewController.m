//
//  MasterViewController.m
//  Beacon Party
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "MasterViewController.h"
#import "Debug.h"

@interface MasterViewController ()
@property (strong,nonatomic) OMDBeaconParty *beaconParty;

@end

@implementation MasterViewController

+ (NSArray *)colorArray
{
    static NSArray *theArray;
    if (!theArray)
    {
        theArray = [[NSArray alloc] initWithObjects:[UIColor blackColor],
                                                    [UIColor darkGrayColor],
                                                    [UIColor lightGrayColor],
                                                    [UIColor whiteColor],
                                                    [UIColor grayColor],
                                                    [UIColor redColor],
                                                    [UIColor greenColor],
                                                    [UIColor blueColor],
                                                    [UIColor cyanColor],
                                                    [UIColor yellowColor],
                                                    [UIColor magentaColor],
                                                    [UIColor orangeColor],
                                                    [UIColor purpleColor],
                                                    [UIColor brownColor],
                                                    nil];
    }
    return theArray;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.beaconParty = [[OMDBeaconParty alloc] init:@"BF5094D9-5849-47ED-8FA1-983A748A9586" identifier:@"com.omdesignllc.beaconparty" debugTextView:self.debugTextView];
    self.beaconParty.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark BeaconParty Delegate
- (void)updateWithBeacon:(CLBeacon*) beacon {
    //Check to see what the app should be doing given the current beacon
    self.view.backgroundColor = [MasterViewController colorArray][beacon.minor.intValue];
    DLog(@"Setting Color to %@ in minor: %d",self.view.backgroundColor.debugDescription,beacon.minor.intValue);
    
}
@end
