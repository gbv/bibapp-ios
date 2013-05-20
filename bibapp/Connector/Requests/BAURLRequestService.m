//
//  BAURLRequestService.m
//  bibapp
//
//  Created by Martin Kim Dung-Pham on 5/19/13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAURLRequestService.h"

@interface BAURLRequestService()

/**
 * @details This is the designated initializer of this service
 */
- (id)initSingleton;

@end

@implementation BAURLRequestService

static id<BAURLRequestService> sharedInstance;

- (id)init
{
   NSException *wrongUsage = [[NSException alloc] initWithName:@"Shared instance exists" reason:@"This is a singleton service class that should not be initialized by calling init()" userInfo:NULL];
   
   [wrongUsage raise];
   
   return nil;
}

- (id)initSingleton
{
   self = [super init];
   return self;
}

#pragma mark - BAURLRequestService methods
+ (id<BAURLRequestService>)sharedInstance
{
   if (!sharedInstance)
   {
      sharedInstance = [[BAURLRequestService alloc] initSingleton];
   }
   return sharedInstance;
}

- (NSURLRequest *)getRequestWithUrl:(NSURL *)url
{
   NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest setHTTPMethod:@"GET"];
   
   return theRequest;
}

- (NSURLRequest *)postRequestWithURL:(NSURL *)url HTTPBody:(NSData *)body contentLength:(NSUInteger)contentLength
{
   NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
   
   [theRequest setHTTPMethod:@"POST"];
   [theRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
   [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
   [theRequest setValue:[NSString stringWithFormat:@"%d", contentLength] forHTTPHeaderField:@"Content-Length"];
   [theRequest setHTTPBody:body];
   
   return theRequest;
}

@end
