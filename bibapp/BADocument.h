//
//  BADocument.h
//  bibapp
//
//  Created by Johannes Schultze on 29.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BADocument : NSObject

@property (strong, nonatomic) NSString *documentID;
@property (strong, nonatomic) NSString *href;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSString *institutionID;
@property (strong, nonatomic) NSString *institution;
@property (strong, nonatomic) NSMutableArray *elements;

@end
