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
#import "WebViewController.h"

#define NOTIFICATION_ALERT_VIEW 1

#define DISMISSED_KEY @"dismissedOverlay"

@interface MasterViewController ()
@property (weak,nonatomic) OMDBeaconPartySchedule* schedule;
-(void) enablePushAndBeacons;
@property (strong,nonatomic) CBCentralManager* cbManager;
- (void) checkBluetoothAccess;
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath compare:@"actioning"] == NSOrderedSame) {
        //Actions occuring and user has stopped - show resume
        if(((NSNumber*)change[NSKeyValueChangeNewKey]).integerValue > 0 && _schedule.scheduler.userStop) {
            dispatch_async(dispatch_get_main_queue(), ^{_resumeButton.hidden = NO; _stopButton.hidden = YES;});
            
        }
        //No actions user but they stopped - Hide both
        else if(((NSNumber*)change[NSKeyValueChangeNewKey]).integerValue == 0 && _schedule.scheduler.userStop) {
            dispatch_async(dispatch_get_main_queue(), ^{_resumeButton.hidden = NO; _stopButton.hidden = YES;});
            
        }
        //No actions user but they didn't stop- Hide both
        else if(((NSNumber*)change[NSKeyValueChangeNewKey]).integerValue == 0 && !_schedule.scheduler.userStop) {
            dispatch_async(dispatch_get_main_queue(), ^{_resumeButton.hidden = YES; _stopButton.hidden = YES;});
            
        }
        //Actions occuring but user has not stopped - show stop
        else if(((NSNumber*)change[NSKeyValueChangeNewKey]).integerValue > 0 && !_schedule.scheduler.userStop) {
            dispatch_async(dispatch_get_main_queue(), ^{_resumeButton.hidden = YES; _stopButton.hidden = NO;});
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{_resumeButton.hidden = YES;_stopButton.hidden = YES;});
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    // Check to see if the overlay has been dismissed before
    // If it hasn't show it again if it isn't currently on the screen
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL dismissed = [defaults boolForKey:DISMISSED_KEY];
    if (!dismissed && _overlay.hidden == YES) {
        
        [UIView transitionWithView:_overlay
                          duration:0.75
                           options:UIViewAnimationOptionTransitionFlipFromBottom
                        animations:^{_overlay.hidden = NO;}
                        completion:NULL];
        
    } else {
            [self checkBluetoothAccess];
        
            if ([UIApplication sharedApplication].enabledRemoteNotificationTypes == UIRemoteNotificationTypeNone){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Push Notifications Needed" message:@"To get the most out of the show please enable Push Notifications." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.tag = NOTIFICATION_ALERT_VIEW;
                [alert show];
            }

        //Enable push and start the beaconing stuff
        [self enablePushAndBeacons];
    }
    
    if(!_schedule) {
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        //Add observer for when scheduler is actioning
        [appDelegate.schedule.scheduler addObserver:self forKeyPath:@"actioning" options:(NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew) context:NULL];
        
        appDelegate.schedule.view = self.pushEffects;
        self.pushEffects.hidden = YES;
#ifdef DEBUG
        _debugTextView.hidden = NO;
        appDelegate.schedule.debugTextView = _debugTextView;
        [appDelegate.schedule test];
#endif
        
        
        _schedule = appDelegate.schedule;
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)resumeTapped:(id)sender {
    _schedule.scheduler.userStop = NO;
    [_schedule setSchedule:_schedule.schedule];
}

- (IBAction)stopTapped:(id)sender {
    _schedule.scheduler.userStop = YES;
    _pushEffects.hidden = YES;
    _resumeButton.hidden = NO;
}

-(IBAction)overlayDismissed:(id) sender {
    //Hide the overlay
    [UIView transitionWithView:_overlay
                      duration:0.75
                       options:UIViewAnimationOptionTransitionFlipFromTop
                    animations:NULL
                    completion:NULL];
    _overlay.hidden = YES;
    //Save the dismissal
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:DISMISSED_KEY];
    [defaults synchronize];
    
    //Now ask for Push permission
    [self enablePushAndBeacons];
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (sender == _eventInfo) {
        WebViewController *wvc = segue.destinationViewController;
        wvc.url = @"http://ziggy.is";
    }
}
-(void) enablePushAndBeacons {
    //Enable Push
    [[UAPush shared] setPushEnabled:YES];
    
    //Enable Beacons
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.schedule setEpoch:[NSDate dateWithTimeIntervalSince1970:0] uuid:UUID identifier:@"is.ziggy"];
    
}

#pragma mark Bluetooth Check
- (void)checkBluetoothAccess {
    
    if(!_cbManager) {
        _cbManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if(central.state == CBCentralManagerStatePoweredOff) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bluetooth Needed"
                                                        message:@"To get the most out of the show please enable Bluetooth." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //    if(alertView.tag == NOTIFICATION_ALERT_VIEW) {
    //        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=General"]];
    //    }
}

@end
