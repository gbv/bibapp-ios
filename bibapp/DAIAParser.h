//
//  DAIAParser.h
//  bibapp
//
//  Created by Johannes Schultze on 07.04.16.
//  Copyright © 2016 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAppDelegate.h"
#import "BADocument.h"
#import "BADocumentItemElementCell.h"
#import "BADocumentItem.h"
#import "BAEntryWork.h"

@interface DAIAParser : NSObject

@property (strong, nonatomic) BAAppDelegate *appDelegate;

-(void)parseDAIAForDocument:(BADocument *)baDocument WithResult:(NSObject *)data;
-(BADocumentItemElementCell *)prepareDAIAForCell:(BADocumentItemElementCell *)cell withItem:(BADocumentItem *)item withEntry:(BAEntryWork *)entry;

@end
