//
//  BAURLRequestService.h
//  bibapp
//
//  Created by Martin Kim Dung-Pham on 5/19/13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BAURLRequestService <NSObject>

+ (id<BAURLRequestService>)sharedInstance;

- (NSURLRequest *)getRequestWithUrl:(NSURL *)url;

@end

@interface BAURLRequestService : NSObject <BAURLRequestService>
@end
