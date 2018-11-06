//
//  BAInstanceItem.m
//  bibapp
//
//  Created by Johannes Schultze on 28.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BADocumentItem.h"
#import "BADocumentItemElement.h"

@implementation BADocumentItem

@synthesize edition;
@synthesize itemID;
@synthesize href;
@synthesize part;
@synthesize message;
@synthesize label;
@synthesize department;
@synthesize storage;
@synthesize available;
@synthesize unavailable;
@synthesize services;
@synthesize uri;
@synthesize location;
@synthesize statusAvailable;
@synthesize statusUnavailable;
@synthesize presentation;
@synthesize presentationHref;
@synthesize presentationExpected;
@synthesize loan;
@synthesize loanHref;
@synthesize loanExpected;
@synthesize interloan;
@synthesize interloanHref;
@synthesize interloanExpected;
@synthesize openaccess;
@synthesize openaccessHref;
@synthesize openaccessExpected;
@synthesize daiaInfoFromOpac;
@synthesize blockOrder;

- (BOOL)order
{
    BOOL result = NO;
    if (!self.blockOrder) {
        for (BADocumentItemElement *service in self.services) {
            if ([service.service isEqualToString:@"loan"]) {
                if (![service.href isEqualToString:@""] && service.href != nil) {
                    result = YES;
                }
            } else if ([service.service isEqualToString:@"presentation"]) {
                for (BADocumentItemElement *tempService in self.services) {
                    if ([tempService.service isEqualToString:@"loan"] && [tempService.type isEqualToString:@"unavailable"]) {
                        if (![service.href isEqualToString:@""] && service.href != nil) {
                            NSRange match = [service.href rangeOfString: @"action=order"];
                            if (match.length > 0) {
                                result = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    return result;
}

@end
