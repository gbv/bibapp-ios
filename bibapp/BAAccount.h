//
//  BAAccount.h
//  bibapp
//
//  Created by Johannes Schultze on 03.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface BAAccount : NSManagedObject

@property (nonatomic, retain) NSString *account;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *token;

@end
