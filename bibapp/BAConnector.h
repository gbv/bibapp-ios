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

@interface BAConnector : NSObject <NSURLConnectionDelegate>

@property (strong, nonatomic) BAAppDelegate *appDelegate;
@property (nonatomic, retain) BAConnector *instance;
@property (retain) id connectorDelegate;
@property (nonatomic, retain) NSString *command;
@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSMutableString *result;
@property (nonatomic, retain) NSData *webDataSynchronous;

+ (id)sharedConnector;
+ (id)generateConnector;
- (void)searchLocalFor:(NSString *)term WithFirst:(int)first WithDelegate:(id)delegate;
- (void)searchCountWithDelegate:(id)delegate;
- (void)searchCentralFor:(NSString *)term WithFirst:(int)first WithDelegate:(id)delegate;
- (void)getUNAPIDetailsFor:(NSString *)ppn WithFormat:(NSString *)format WithDelegate:(id)delegate;
- (void)getDetailsForLocal:(NSString *)ppn WithDelegate:(id)delegate;
- (void)getDetailsFor:(NSString *)ppn WithDelegate:(id)delegate;
- (void)getCoverFor:(NSString *)number WithDelegate:(id)delegate;
- (void)loginWithAccount:(NSString *)account WithPassword:(NSString *)password WithDelegate:(id)delegate;
- (void)accountLoadLoanListWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadReservedListWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadFeesWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadInterloanWithAccount:(NSString *)account ListWithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountRequestDocs:(NSMutableArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountRenewDocs:(NSMutableArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountCancelDocs:(NSMutableArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)accountLoadPatronWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate;
- (void)getInfoFeedWithDelegate:(id)delegate;
- (void)getLocationInfoForUri:(NSString *)uri WithDelegate:(id)delegate;
- (void)getLocationsForLibraryByUri:(NSString *)uri WithDelegate:(id)delegate;
- (BALocation *)loadLocationForUri:(NSString *)uri;

@end
