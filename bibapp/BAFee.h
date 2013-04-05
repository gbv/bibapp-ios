//
//  BAFee.h
//  bibapp
//
//  Created by Johannes Schultze on 04.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAFee : NSObject

@property (strong, nonatomic) NSString *about;
@property (strong, nonatomic) NSString *amount;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *edition;
@property (strong, nonatomic) NSString *item;
@property BOOL sum;

@end
