//
//  BAInstanceItem.h
//  bibapp
//
//  Created by Johannes Schultze on 28.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BALocation.h"

@interface BADocumentItem : NSObject

@property (strong, nonatomic) NSString *edition;
@property (strong, nonatomic) NSString *itemID;
@property (strong, nonatomic) NSString *href;
@property (strong, nonatomic) NSString *part;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *department;
@property (strong, nonatomic) NSString *storage;
@property (strong, nonatomic) NSString *uri;
@property (strong, nonatomic) BALocation *location;
@property (strong, nonatomic) NSMutableArray *available;
@property (strong, nonatomic) NSMutableArray *unavailable;
@property (strong, nonatomic) NSMutableArray *services;
@property (nonatomic) NSInteger statusAvailable;
@property (nonatomic) NSInteger statusUnavailable;
@property BOOL presentation;
@property (strong, nonatomic) NSString *presentationHref;
@property (strong, nonatomic) NSString *presentationExpected;
@property BOOL loan;
@property (strong, nonatomic) NSString *loanHref;
@property (strong, nonatomic) NSString *loanExpected;
@property BOOL interloan;
@property (strong, nonatomic) NSString *interloanHref;
@property (strong, nonatomic) NSString *interloanExpected;
@property BOOL openaccess;
@property (strong, nonatomic) NSString *openaccessHref;
@property (strong, nonatomic) NSString *openaccessExpected;
@property BOOL daiaInfoFromOpac;

- (BOOL)order;

@end
