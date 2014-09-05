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

@interface AppDelegate : UIResponder <UIApplicationDelegate,UAPushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (weak,nonatomic) OMDBeaconPartySchedule* schedule;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
