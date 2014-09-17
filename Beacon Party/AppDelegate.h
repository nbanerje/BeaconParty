//
//  AppDelegate.h
//  Beacon Party
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "OMDBeaconPartySchedule.h"
#import "UAirship.h"
#import "UAPush.h"

#define UUID @"BF5094D9-5849-47ED-8FA1-983A748A9586"

typedef void(^FetchURLDataBlock)(NSString*, OMDBeaconPartySchedule*, void (^)(UIBackgroundFetchResult));
typedef void (^BackgroundCompletion)(UIBackgroundFetchResult);

extern FetchURLDataBlock fetchURLData;


@interface AppDelegate : UIResponder <UIApplicationDelegate,UAPushNotificationDelegate,CBCentralManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) OMDBeaconPartySchedule* schedule;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;





@end
