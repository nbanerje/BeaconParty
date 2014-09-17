//
//  MasterViewController.h
//  Beacon Party
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OMDBeaconParty.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface MasterViewController : UIViewController <CBCentralManagerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *debugTextView;
@property (weak, nonatomic) IBOutlet UIView *pushEffects;
@property (weak, nonatomic) IBOutlet UIView *overlay;

@property (weak,nonatomic) IBOutlet UIButton *strobe;
@property (weak,nonatomic) IBOutlet UIButton *ziggify;
@property (weak,nonatomic) IBOutlet UIButton *eventInfo;
@property (weak,nonatomic) IBOutlet UINavigationItem *navBar;

-(IBAction)overlayDismissed:(id) sender;
@end
