//
//  SCConnector.h
//  CommSy
//
//  Created by Johannes Schultze on 16.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAppDelegate.h"
#import "BAConnectorDelegate.h"
#import "BALocation.h"
#import "Reachability.h"

@interface BAConnector : NSObject <NSURLConnectionDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionTaskDelegate>

FOUNDATION_EXPORT NSString *const ERROR_MESSAGE_SCOPE;
FOUNDATION_EXPORT NSString *const ERROR_MESSAGE_NETWORK_REACHABILITY;

@property (strong, nonatomic) BAAppDelegate *appDelegate;
@property (nonatomic, retain) BAConnector *instance;
@property (retain) id connectorDelegate;
@property (nonatomic, retain) NSString *command;
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSMutableString *result;
@property (nonatomic, retain) NSData *webDataSynchronous;
@property (nonatomic, retain) NSURLConnection *currentConnection;
@property (nonatomic, retain) NSString *baseURL;
@property (nonatomic, strong) NSDictionary *urlencodeCharacters;

+ (id)sharedConnector;
+ (id)generateConnector;
- (void)searchLocalFor:(NSString *)term WithFirst:(long)first WithDelegate:(id)delegate;
- (void)searchLocalFor:(NSString *)term WithPicaParameter:(NSString *)picaParameter WithFirst:(long)first WithDelegate:(id)delegate;
- (void)searchCountWithDelegate:(id)delegate;
- (void)searchCentralFor:(NSString *)term WithFirst:(long)first WithDelegate:(id)delegate;
- (void)getUNAPIDetailsFor:(NSString *)ppn WithFormat:(NSString *)format WithDelegate:(id)delegate;
- (void)getDetailsForLocal:(NSString *)ppn WithDelegate:(id)delegate;
- (void)getDetailsFor:(NSString *)ppn WithDelegate:(id)delegate;
- (void)getCoverFor:(NSString *)number WithDelegate:(id)delegate;
- (void)loginWithAccount:(NSString *)account WithPassword:(NSString *)password WithDelegate:(id)delegate;
- (void)logoutWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadLoanListWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadReservedListWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadFeesWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadInterloanWithAccount:(NSString *)account ListWithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountRequestDocs:(NSArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountRenewDocs:(NSArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountCancelDocs:(NSArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadPatronWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)getInfoFeedWithDelegate:(id)delegate;
- (void)getLocationInfoForUri:(NSString *)uri WithDelegate:(id)delegate;
- (void)getLocationsForLibraryByUri:(NSString *)uri WithDelegate:(id)delegate;
- (BALocation *)loadLocationForUri:(NSString *)uri;
- (void)loadLocationForUri:(NSString *)uri WithDelegate:(id)delegate;
- (BALocation *)parseLocation:(NSData *)locationData ForUri:(NSString *)uri;
- (BALocation *)loadLocationFromCacheForUri:(NSString *)uri;
- (BOOL)checkScope:(NSString *)scope;
- (void)displayError;
- (BOOL)checkNetworkReachability;
- (NSString *)loadISBDWithPPN:(NSString *)ppn;
- (void)getDetailsForLocalFam:(NSString *)ppn WithStart:(long)start WithDelegate:(id)delegate;

- (void)pushServiceRegisterWithPatron:(NSString *)patron deviceId:(NSString *)deviceId delegate:(id)delegate;
- (void)pushServiceUpdateWithPatron:(NSString *)patron deviceId:(NSString *)deviceId delegate:(id)delegate;
- (void)pushServiceUpdateWithDeviceId:(NSString *)deviceId delegate:(id)delegate;
- (void)pushServiceRemoveWithPushServerId:(NSString *)pushServerId delegate:(id)delegate;

@end
