//
//  OMDBeaconParty.h
//  Beacon Party
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol OMDBeaconPartyDelegate<NSObject>
@required
- (void)updateWithBeacon:(CLBeacon*) beacon;
@end


@interface OMDBeaconParty : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) UITextView *debugTextView;
@property (weak, nonatomic) id <OMDBeaconPartyDelegate> delegate;

- (id)init:(NSString*)UUID identifier:(NSString*)identifier debugTextView:(UITextView*)debugTextView;


@end

