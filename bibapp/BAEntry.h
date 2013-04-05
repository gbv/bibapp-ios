//
//  BAEntry.h
//  bibapp
//
//  Created by Johannes Schultze on 01.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BAEntry : NSManagedObject

@property (nonatomic, retain) NSString *ppn;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSString *matstring;
@property (nonatomic, retain) NSString *matcode;
@property (nonatomic, retain) NSString *author;
@property BOOL local;

@end
