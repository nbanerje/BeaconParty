//
//  AppDelegate.m
//  Beacon Party
//
//  Created by Neel Banerjee on 8/23/14.
//  Copyright (c) 2014 Neel Banerjee. All rights reserved.
//

#import "AppDelegate.h"

#import "MasterViewController.h"

#import "UAConfig.h"

#define FETCH_URL_STR @"http://omdesignllc.com/sample.json"

UIBackgroundFetchResult(^fetchURLData)(NSString*,OMDBeaconPartySchedule*)  = ^UIBackgroundFetchResult (NSString* url,OMDBeaconPartySchedule* schedule){
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [sharedSession dataTaskWithURL:[NSURL URLWithString:url] completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error){
                                      if(error) {
                                          NSLog(@"Failed %@",[error debugDescription]);
                                      } else {
                                          if(response) {
                                              [schedule loadScheduleFromJsonData:data];
                                              NSLog(@"fetch data");
                                          }
                                      }
                                  }];
    [task resume];
    return UIBackgroundFetchResultNewData;
};

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UAPush setDefaultPushEnabledValue:NO];
    
    // Set log level for debugging config loading (optional)
    // It will be set to the value in the loaded config upon takeOff
    [UAirship setLogLevel:UALogLevelTrace];
    
    // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
    // or set runtime properties here.
    UAConfig *config = [UAConfig defaultConfig];
    
    // You can then programatically override the plist values:
    // config.developmentAppKey = @"YourKey";
    // etc.
    
    // Call takeOff (which creates the UAirship singleton)
    // You may also simply call [UAirship takeOff] without any arguments if you want
    // to use the default config loaded from AirshipConfig.plist
    [UAirship takeOff:config];
    [UAPush shared].pushNotificationDelegate = self;
    
    // Print out the application configuration for debugging (optional)
    UA_LDEBUG(@"Config:\n%@", [config description]);
    
    // Set the icon badge to zero on startup (optional)
    [[UAPush shared] resetBadge];
    
    // Set the notification types required for the app (optional). With the default value of push set to no,
    // UAPush will record the desired remote notification types, but not register for
    // push notifications as mentioned above. When push is enabled at a later time, the registration
    // will occur normally. This value defaults to badge, alert and sound, so it's only necessary to
    // set it if you want to add or remove types.
    [UAPush shared].notificationTypes = (UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert);
    
    [[UAPush shared] setPushEnabled:YES];

    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Beacon_Party" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Beacon_Party.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Background fetch delegate methods

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    UIBackgroundFetchResult fetchResult = fetchURLData(FETCH_URL_STR,_schedule);
    completionHandler(fetchResult);
}

#pragma mark - Push Delegate
- (void)receivedForegroundNotification:(NSDictionary *)notification
                fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    UA_LDEBUG(@"Received a notification while the app was already in the foreground");

    UIBackgroundFetchResult fetchResult = UIBackgroundFetchResultNoData;
    // Do something with your customData JSON, then entire notification is also available
    if(notification[@"data-url"]) {
        fetchResult = fetchURLData(FETCH_URL_STR,_schedule);
    }
    // Be sure to call the completion handler with a UIBackgroundFetchResult
    
    completionHandler(fetchResult);
}

- (void)launchedFromNotification:(NSDictionary *)notification
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    UA_LDEBUG(@"The application was launched or resumed from a notification");
    
    UIBackgroundFetchResult fetchResult = UIBackgroundFetchResultNoData;
    // Do something with your customData JSON, then entire notification is also available
    if(notification[@"data-url"]) {
        fetchResult = fetchURLData(FETCH_URL_STR,_schedule);
    }
    // Be sure to call the completion handler with a UIBackgroundFetchResult
    
    completionHandler(fetchResult);
}

- (void)receivedBackgroundNotification:(NSDictionary *)notification
                fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    UIBackgroundFetchResult fetchResult = UIBackgroundFetchResultNoData;
    // Do something with your customData JSON, then entire notification is also available
    if(notification[@"data-url"]) {
        fetchResult = fetchURLData(FETCH_URL_STR,_schedule);
    }
    // Be sure to call the completion handler with a UIBackgroundFetchResult
    
    completionHandler(fetchResult);
}


@end
