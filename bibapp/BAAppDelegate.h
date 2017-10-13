//
//  testAppDelegate.h
//  bibapp
//
//  Created by Johannes Schultze on 25.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BAAccount.h"
#import "BAOptions.h"
#import "BAConfiguration.h"
#import "BAPushService.h"

@interface BAAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (strong, nonatomic) NSString *currentAccount;
@property (strong, nonatomic) NSString *currentPassword;
@property (strong, nonatomic) NSString *currentToken;
@property (strong, nonatomic) NSArray *currentScope;
@property (strong, nonatomic) BAAccount *account;
@property (strong, nonatomic) BAOptions *options;
@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) BAConfiguration *configuration;
@property BOOL isIOS7;
@property BOOL isLoggedIn;
@property BAPushService *pushService;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
