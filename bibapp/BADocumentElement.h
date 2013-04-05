//
//  BADocumentElement.h
//  bibapp
//
//  Created by Johannes Schultze on 30.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BADocumentElement : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *value;

@end
