//
//  AppDelegate.h
//  Beacon Party
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMDBeaconPartySchedule.h"
#import "UAirship.h"
#import "UAPush.h"

#define FETCH_URL_STR @"http://omdesignllc.com/sample.json"

typedef void(^FetchURLDataBlock)(NSString*, OMDBeaconPartySchedule*, void (^)(UIBackgroundFetchResult));
typedef void (^BackgroundCompletion)(UIBackgroundFetchResult);

extern FetchURLDataBlock fetchURLData;


@interface AppDelegate : UIResponder <UIApplicationDelegate,UAPushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) OMDBeaconPartySchedule* schedule;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;





@end
