//
//  BAPushService.m
//  bibapp
//
//  Created by Johannes Schultze on 12.10.17.
//  Copyright © 2017 Johannes Schultze. All rights reserved.
//

#import "BAPushService.h"
#import "BAConnector.h"

#import <Firebase/Firebase.h>

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

// Implement UNUserNotificationCenterDelegate to receive display notification via APNS for devices
// running iOS 10 and above.
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface BAPushService () <UNUserNotificationCenterDelegate>
@end
#endif

// Copied from Apple's header in case it is missing in some cases (e.g. pre-Xcode 8 builds).
#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@implementation BAPushService

- (id)init
{
    self = [super init];
    if (self) {
        self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

-(void)enablePush {
    NSLog(@"enable push");
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
        #if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        #endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
    NSLog(@"FCM registration token: %@", fcmToken);
    
    BAConnector *connector = [BAConnector generateConnector];
    //[connector pushServiceRegisterWithUsername:self.appDelegate.currentAccount password:self.appDelegate.currentPassword deviceId:fcmToken delegate:self];
    
    [connector pushServiceRegisterWithUsername:@"BibApp" password:@"Password" deviceId:fcmToken delegate:self];
}

-(void)disablePush {
    NSLog(@"disable push");
    
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    
    BAConnector *connector = [BAConnector generateConnector];
    [connector pushServiceRemoveWithdelegate:self];
}

-(void)updatePush {
    NSLog(@"update push");
    
    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
    NSLog(@"FCM registration token: %@", fcmToken);
    
    BAConnector *connector = [BAConnector generateConnector];
    [connector pushServiceUpdateWithUsername:self.appDelegate.currentAccount password:self.appDelegate.currentPassword deviceId:fcmToken delegate:self];
}

-(void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result {
    if ([command isEqualToString:@"pushServiceRegister"]) {
        
        NSError* error;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:&error];
        
        NSLog(@"%@", json);
    } else if ([command isEqualToString:@"pushServiceUpdate"]) {
        
    } else if ([command isEqualToString:@"pushServiceUpdateDeviceId"]) {
        
    } else if ([command isEqualToString:@"pushServiceRemove"]) {
        
    }
}

-(void)commandIsNotInScope:(NSString *)command {
    
}

-(void)networkIsNotReachable:(NSString *)command {
    
}

@end
