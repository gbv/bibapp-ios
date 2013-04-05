//
//  BALocation.h
//  bibapp
//
//  Created by Johannes Schultze on 28.01.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface BALocation : NSManagedObject

@property (nonatomic, retain) NSString * uri;
@property (nonatomic, retain) NSString * geoLong;
@property (nonatomic, retain) NSString * geoLat;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * shortname;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * openinghours;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * desc;

@end
