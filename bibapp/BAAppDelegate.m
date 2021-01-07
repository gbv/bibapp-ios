//
//  testAppDelegate.m
//  bibapp
//
//  Created by Johannes Schultze on 25.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAAppDelegate.h"
#import "BAOptions.h"
#import "BALocalizeHelper.h"

#import <Firebase/Firebase.h>

NSString *const kGCMMessageIDKey = @"gcm.message_id";

@implementation BAAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize locationManager;
@synthesize currentAccount;
@synthesize currentPassword;
@synthesize currentToken;
@synthesize options;
@synthesize locations;
@synthesize configuration;
@synthesize isIOS7;
@synthesize isLoggedIn;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.isIOS7 = NO;
    NSString *reqSysVer = @"7.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending) {
        self.isIOS7 = YES;
    }
    
    self.configuration = [BAConfiguration createConfiguration];
    
    if (self.isIOS7) {
        [self.window setTintColor:self.configuration.currentBibTintColor];
    }
   
    NSString *userAgent = [[NSString alloc] initWithFormat:@"BibApp/%@ (iOS)", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];
   
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BAOptions" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *tempOptionsArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if([tempOptionsArray count] == 0){
        self.options = (BAOptions *)[NSEntityDescription insertNewObjectForEntityForName:@"BAOptions" inManagedObjectContext:[self managedObjectContext]];
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
        }
    } else {
        self.options = [tempOptionsArray objectAtIndex:0];
    }
    
    // if the selected catalogue has not been set, the app is started for the first time.
    if ([self.options.selectedCatalogue isEqualToString:@""] || self.options.selectedCatalogue == nil) {
        [self.options setSelectedCatalogue:self.configuration.currentBibStandardCatalogue];
        [self.options setAllowCountPixel:YES];
        [self.options setSelectedLanguage:self.configuration.currentBibStandardLanguage];
        NSError *error = nil;
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
        }
    }
    
    NSEntityDescription *entityDescriptionAccount = [NSEntityDescription entityForName:@"BAAccount" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *requestAcount = [[NSFetchRequest alloc] init];
    [requestAcount setEntity:entityDescriptionAccount];
    
    NSArray *tempAccountArray = [self.managedObjectContext executeFetchRequest:requestAcount error:&error];
    
    if([tempAccountArray count] == 0){
        self.account = (BAAccount *)[NSEntityDescription insertNewObjectForEntityForName:@"BAAccount" inManagedObjectContext:[self managedObjectContext]];
        if (![[self managedObjectContext] save:&error]) {
            // Handle the error.
        }
    } else {
        self.account = [tempAccountArray objectAtIndex:0];
    }
    self.isLoggedIn = NO;
   
    // Load cached locations
    NSEntityDescription *entityDescriptionLocations = [NSEntityDescription entityForName:@"BALocation" inManagedObjectContext:[self managedObjectContext]];
    NSFetchRequest *requestLocation = [[NSFetchRequest alloc] init];
    [requestLocation setEntity:entityDescriptionLocations];
    [self setLocations:[[self.managedObjectContext executeFetchRequest:requestLocation error:&error] mutableCopy]];
    
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        self.locationManager.delegate = self;
    }
    [self.locationManager startUpdatingLocation];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:self.configuration.pushServiceGoogleServiceFile ofType:@"plist"];
    FIROptions *options = [[FIROptions alloc] initWithContentsOfFile:filePath];
    [FIRApp configureWithOptions:options];
    //[FIRApp configure];
    
    self.pushService = [[BAPushService alloc] init];
    
    application.applicationIconBadgeNumber = 0;

    BALocalizationSetLanguage(self.options.selectedLanguage);
    
    //setenv("CFNETWORK_DIAGNOSTICS", "3", 1);
    
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
    application.applicationIconBadgeNumber = 0;
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
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
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
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"bibapp" withExtension:@"momd"];
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
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"bibapp.sqlite"];
    
    // handle db upgrade
    NSDictionary *storeOptions = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:storeOptions error:&error]) {
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

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    [self switchToAccountTab];
    
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)switchToAccountTab {
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    tabBarController.selectedIndex = 1;
}

@end
