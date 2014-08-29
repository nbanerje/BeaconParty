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
@property (strong, nonatomic) NSNumber *bestBeaconMinor;
@property (assign, nonatomic) NSUInteger bestBeaconIndex;
@property (assign, nonatomic) CLProximity bestProximity;
@property (assign, nonatomic) NSInteger bestRssi;
@property (assign, nonatomic) double bestAccuracy;

@end

@implementation OMDBeaconParty

- (id)init:(NSString*)UUID identifier:(NSString*)identifier debugTextView:(UITextView*)debugTextView {
    self = [super init];
    
    if(self) {
        self.debugTextView = debugTextView;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self initRegion:UUID identifier:identifier];
        self.bestBeaconIndex = -1;
        self.bestProximity = CLProximityUnknown;
        self.bestRssi = -999;
        self.bestAccuracy = ~0ul;
        
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

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    DLog(@"Exited Region: %@", [region debugDescription]);
}

-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
    NSUInteger index = 0;
    BOOL foundBetter = NO;
    for (CLBeacon *beacon in beacons) {
        //TODO: Determine the best way to know if we should choose a better beacon
        BOOL betterCondition = beacon.proximity != CLProximityUnknown &&
                               beacon.minor.intValue != _bestBeaconMinor.intValue &&
                               beacon.rssi > _bestRssi &&
                               beacon.accuracy < self.bestAccuracy;
        
        //DLog(@"C minor:%d prox:%d acc:%f rssi:%d", _bestBeaconMinor.intValue, _bestProximity, _bestAccuracy, _bestRssi);
        //DLog(@"B minor:%d prox:%d acc:%f rssi:%d", beacon.minor.intValue, beacon.proximity, beacon.accuracy, beacon.rssi);
        
        
        if(betterCondition) {
            DLog(@"Found better beacon idx:%lu minor:%d", (unsigned long)index, beacon.minor.intValue);
            self.bestProximity = beacon.proximity;
            self.bestAccuracy = beacon.accuracy;
            self.bestRssi = beacon.rssi;
            self.bestBeaconIndex = index;
            self.bestBeaconMinor = [beacon.minor copy];
            foundBetter = YES;
        }
        index++;
        
    }

    if(foundBetter) {
        [self.delegate updateWithBeacon:beacons[self.bestBeaconIndex]];
    }
    

}

- (void)locationManager:(CLLocationManager *)manager
rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region
              withError:(NSError *)error {
    DLog(@"Error %@",[error debugDescription]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    });
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
