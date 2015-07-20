//
//  BAEntry.h
//  bibapp
//
//  Created by Johannes Schultze on 20.07.15.
//  Copyright (c) 2015 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BAEntry : NSManagedObject

@property (nonatomic, retain) NSString * author;
@property BOOL local;
@property (nonatomic, retain) NSString * matcode;
@property (nonatomic, retain) NSString * matstring;
@property (nonatomic, retain) NSString * ppn;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * year;

@end
