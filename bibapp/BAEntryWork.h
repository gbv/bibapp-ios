//
//  BAItem.h
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAEntryWork : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSString *infoText;
@property (strong, nonatomic) NSString *ppn;
@property (strong, nonatomic) NSString *matstring;
@property (strong, nonatomic) NSString *matcode;
@property BOOL local;
@property BOOL canRenewCancel;
@property (strong, nonatomic) NSString *item;
@property (strong, nonatomic) NSString *edition;
@property (strong, nonatomic) NSString *bar;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *duedate;
@property (strong, nonatomic) NSString *starttime;
@property (strong, nonatomic) NSString *endtime;
@property (strong, nonatomic) NSString *queue;
@property (strong, nonatomic) NSString *renewal;
@property (strong, nonatomic) NSString *storage;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSString *toc;
@property (strong, nonatomic) NSMutableArray *tocArray;
@property (strong, nonatomic) NSString *onlineLocation;
@property (strong, nonatomic) NSString *author;
@property BOOL selected;
@property (strong, nonatomic) NSString *mediaIconPhysicalDescriptionForm;
@property (strong, nonatomic) NSString *mediaIconTypeOfResourceManuscript;
@property (strong, nonatomic) NSString *mediaIconTypeOfResource;
@property (strong, nonatomic) NSString *mediaIconRelatedItemType;
@property (strong, nonatomic) NSString *mediaIconDisplayLabel;
@property (strong, nonatomic) NSString *mediaIconOriginInfoIssuance;
@property (strong, nonatomic) NSString *partName;
@property (strong, nonatomic) NSString *partNumber;
@property (strong, nonatomic) NSString *isbn;
@property (strong, nonatomic) NSString *year;

- (UIImage *)mediaIcon;
- (NSString *)statusDisplay;

@end
