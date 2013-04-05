//
//  BAInfoItem.h
//  bibapp
//
//  Created by Johannes Schultze on 28.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAInfoItem : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *link;

@end
