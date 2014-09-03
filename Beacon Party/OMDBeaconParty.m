//
//  OMDBeaconParty.m
//  Beacon Party
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//
#import "OMDBeaconParty.h"
#import "Debug.h"


@interface OMDBeaconParty()

- (void)initRegion:(NSString*)UUID identifier:(NSString*)identifier;
@property (strong, nonatomic) CLBeacon *bestBeacon;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation OMDBeaconParty

- (id)init:(NSString*)UUID identifier:(NSString*)identifier debugTextView:(UITextView*)debugTextView {
    self = [super init];
    
    if(self) {
        self.debugTextView = debugTextView;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self initRegion:UUID identifier:identifier];
    }
    return self;
    
}

- (void)initRegion:(NSString*)UUID identifier:(NSString*)identifier {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:UUID];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:identifier];
    self.beaconRegion.notifyEntryStateOnDisplay = YES;
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    DLog(@"startMonitoringForRegion");
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    DLog(@"Entered Region: %@", [region debugDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    DLog(@"Exited Region: %@", [region debugDescription]);
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSPredicate *predicateIrrelevantBeacons =
        [NSPredicate predicateWithFormat:@"(self.accuracy != -1) AND ((self.proximity != %d) OR (self.proximity != %d))", CLProximityFar,CLProximityUnknown];
    NSArray *relevantsBeacons = [beacons filteredArrayUsingPredicate: predicateIrrelevantBeacons];
    NSPredicate *predicateMin = [NSPredicate predicateWithFormat:@"self.accuracy == %@.@min.accuracy", relevantsBeacons];
    CLBeacon *closestBeacon = nil;
    NSArray *closestArray = [relevantsBeacons filteredArrayUsingPredicate:predicateMin];
    
    if ([closestArray count] > 0) {
        closestBeacon = [closestArray objectAtIndex:0];
    }
    
    if (closestBeacon && closestBeacon != _bestBeacon) {
        _bestBeacon = closestBeacon;
        DLog(@"Found better beacon minor:%@", [_bestBeacon debugDescription]);
        [self.delegate updateWithBeacon:_bestBeacon];
    }

}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error {
    DLog(@"Error %@",[error debugDescription]);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
//    });
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    DLog(@"Error %@",[error debugDescription]);
}

- (void)locationManager:(CLLocationManager *)manager
monitoringDidFailForRegion:(CLRegion *)region
              withError:(NSError *)error {
    DLog(@"Error %@",[error debugDescription]);
}

- (void)locationManager:(CLLocationManager *)manager
didStartMonitoringForRegion:(CLRegion *)region {
    DLog(@"Started region:%@",[region debugDescription]);
}

- (void)locationManager:(CLLocationManager *)manager
didFinishDeferredUpdatesWithError:(NSError *)error {
    DLog(@"Error %@",[error debugDescription]);
}

@end
