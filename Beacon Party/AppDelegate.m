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

#import "UATagUtils.h"


#define UUID @"BF5094D9-5849-47ED-8FA1-983A748A9586"

#define OMDPICURL @"http://omdesignllc.com"
#define PATH @"checkKey.php"
#define UPLOAD_PATH @"postPic.php"
#define DB_FILENAME @"media.sql"


//typedef void(^FetchURLDataBlock)(NSString*, OMDBeaconPartySchedule*, void (^)(UIBackgroundFetchResult));
//typedef void (^BackgroundCompletion)(UIBackgroundFetchResult);

FetchURLDataBlock fetchURLData  = ^ (NSString* url,OMDBeaconPartySchedule* schedule, BackgroundCompletion completionHandler){
    NSURLSession *sharedSession = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [sharedSession dataTaskWithURL:[NSURL URLWithString:url] completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error){
                                      if(error) {
                                          NSLog(@"Failed %@",[error debugDescription]);
                                          completionHandler(UIBackgroundFetchResultFailed);
                                      } else {
                                          if(data.length >0) {
                                              [schedule loadScheduleFromJsonData:data];
                                              [OMDBeaconPartySchedule saveData:data];
                                              NSLog(@"fetch data");
                                              if(completionHandler) completionHandler(UIBackgroundFetchResultNewData);
                                          }
                                          else {
                                              if(completionHandler) completionHandler(UIBackgroundFetchResultNoData);
                                          }
                                      }
                                  }];
    [task resume];
};

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Check to see if a saved schedule exists. If not download the latest.
    
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
    
    [[UAPush shared] addTagsToCurrentDevice:[UATagUtils createTags:UATagTypeCountry|UATagTypeDeviceType|UATagTypeLanguage|UATagTypeTimeZone|UATagTypeTimeZoneAbbreviation]];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    
    [[UAPush shared] addTagToCurrentDevice:build];
    [[UAPush shared] updateRegistration];
    
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    _schedule = [OMDBeaconPartySchedule shared];
    [_schedule setEpoch:[NSDate dateWithTimeIntervalSince1970:0] uuid:UUID identifier:@"is.ziggy"];
    
    //Pics Snapping Portion
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-11960342-5"];
    // Set the log level to verbose.
    [[GAI sharedInstance].logger setLogLevel:kGAILogLevelError];
    self.cred = [[OmDesignCredential alloc] init];
    
    [[OMDMediaDB sharedInstance] initWithFilename:DB_FILENAME];
    [[OMDMediaDB sharedInstance] createEditableCopyOfDatabaseIfNeeded];
    [[OMDMediaDB sharedInstance] initializeDatabase];
    
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    [self batteryStatus:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyFailed) name:@"KeyFailed" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyPassed) name:@"KeyPassed" object:nil];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStatus:) name:UIDeviceBatteryStateDidChangeNotification object:nil];
    
	self.settingsDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
	
	self.key = [NSMutableString stringWithFormat:@"doe2013"];
    [self.cred checkKey:self.key url:OMDPICURL path:PATH];
//	[self.key setString:@""];
//	NSDictionary *savedDict = [SaveData applicationPlistFromFile:@"key.plist"];
//	//If the key exists, use it
//	if(savedDict != nil) {
//		[self.settingsDictionary addEntriesFromDictionary:savedDict];
//		if([self.settingsDictionary objectForKey:@"key"] != nil) {
//			[self.key setString:[self.settingsDictionary objectForKey:@"key"]];
//		}
//    }
    
	[[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [self setSaveKey];
    [[OMDMediaDB sharedInstance] setUploadPaused:YES];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self setSaveKey];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self setSaveKey];
    OMDMediaDB *mediaDB = [OMDMediaDB sharedInstance];
    mediaDB.uploadPaused = NO;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self setSaveKey];
    OMDMediaDB *mediaDB = [OMDMediaDB sharedInstance];
    mediaDB.uploadPaused = NO;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self setSaveKey];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"KeyFailed"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"KeyPassed"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:UIDeviceBatteryStateDidChangeNotification];
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
        //abort();
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
    fetchURLData(FETCH_URL_STR,_schedule,completionHandler);
    
}

#pragma mark - Push Delegate
- (void)receivedForegroundNotification:(NSDictionary *)notification
                fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    UA_LDEBUG(@"Received a notification while the app was already in the foreground");

    if(notification[@"data-url"]) {
        fetchURLData(notification[@"data-url"],_schedule,completionHandler);
    }
    else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)launchedFromNotification:(NSDictionary *)notification
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    UA_LDEBUG(@"The application was launched or resumed from a notification");
    
    if(notification[@"data-url"]) {
        fetchURLData(notification[@"data-url"],_schedule,completionHandler);
    }
    else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)receivedBackgroundNotification:(NSDictionary *)notification
                fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if(notification[@"data-url"]) {
        fetchURLData(notification[@"data-url"],_schedule,completionHandler);
    }
    else {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

#pragma mark copied methods from pic capture
- (void)setSaveKey {
	[self.settingsDictionary setObject:self.key forKey:@"key"];
	[SaveData writeApplicationPlist:self.settingsDictionary toFile:@"key.plist"];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    [[OMDMediaDB sharedInstance] killUploadsAndPause];
}

-(void)keyPassed {
	
    
    [self setSaveKey];
    
    OMDMediaDB *mediaDB = [OMDMediaDB sharedInstance];
    [mediaDB startUploading:OMDPICURL path:UPLOAD_PATH];
    
    self.keyPassedAlertView = [[UIAlertView alloc] initWithTitle:@"Great!"
                                                         message:@"You're authorized! Start taking pics!"
                                                        delegate:self cancelButtonTitle:@"Sweet!" otherButtonTitles:nil];
    
	[self.keyPassedAlertView show];
    
    // May return nil if a tracker has not yet been initialized with a property ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"credential"     // Event category (required)
                                                          action:@"key_passed"  // Event action (required)
                                                           label:self.key          // Event label
                                                           value:nil] build]];    // Event value
	
}

-(void)keyFailed {
	self.keyFailedAlertView = [[UIAlertView alloc] initWithTitle:@"Sorry..."
                                                         message:@"Wrong key. Tap on key to re-entering it. Maybe you mistyped?"
                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[self.keyFailedAlertView show];
	
}

- (void)batteryStatus:(NSNotification *)notification
{
    UIDevice *device = [UIDevice currentDevice];
    NSLog(@"State: %i Charge: %f", device.batteryState, device.batteryLevel);
    if(device.batteryState == UIDeviceBatteryStateCharging && [[NSUserDefaults standardUserDefaults] boolForKey:@"display_on_charging"]) {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    else {
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    }
}



@end
