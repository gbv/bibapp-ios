//
//  BAURLRequestService.h
//  bibapp
//
//  Created by Martin Kim Dung-Pham on 5/19/13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BAURLRequestService <NSObject>

/**
 * @return The instance of this service
 */
+ (id<BAURLRequestService>)sharedInstance;

/**
 * @return A NSURLRequest with HTTP method GET and the given request URL
 * @param url The URL of the request
 */
- (NSMutableURLRequest *)getRequestWithUrl:(NSURL *)url;

/**
 * @return NSURLRequest with HTTP method POST
 * @param url The URL of the request
 * @param body The data to send with the request
 * @param contentLength The value of the HTTP header field "Content-Length"
 */
- (NSMutableURLRequest *)postRequestWithURL:(NSURL *)url HTTPBody:(NSData *)body contentLength:(NSUInteger)contentLength;

@end

@interface BAURLRequestService : NSObject <BAURLRequestService>
@end
