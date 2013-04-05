//
//  BAInstanceItemElement.h
//  bibapp
//
//  Created by Johannes Schultze on 29.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BADocumentItemElement : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *href;
@property (strong, nonatomic) NSString *service;
@property (strong, nonatomic) NSString *delay;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *limitation;
@property (strong, nonatomic) NSString *expected;
@property (strong, nonatomic) NSString *queue;
@property BOOL available;
@property BOOL order;

@end
