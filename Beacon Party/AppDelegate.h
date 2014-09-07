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


#import "OMDFirstViewController.h"
#import "OMDSecondViewController.h"
#import "OmDesignCredential.h"
#import "SaveData.h"
#import "OMDMediaDB.h"

#import "OmDesignCredential.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"
#import "GAIFields.h"




@interface AppDelegate : UIResponder <UIApplicationDelegate,UAPushNotificationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) OMDBeaconPartySchedule* schedule;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (nonatomic, retain) NSMutableDictionary *settingsDictionary;

@property (nonatomic, strong) OmDesignCredential *cred;

#ifdef KEYCHAIN
@property (nonatomic,strong) KeychainItemWrapper *keychain;
#endif
@property (nonatomic, strong) NSMutableString *key;
@property (nonatomic, strong) UIAlertView* keyFailedAlertView;
@property (nonatomic, strong) UIAlertView* keyPassedAlertView;


-(void)keyFailed;
-(void)setSaveKey;



@end
