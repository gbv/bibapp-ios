//
//  BADocumentItemElementCellNonLocalPad.m
//  bibapp
//
//  Created by Johannes Schultze on 26.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BADocumentItemElementCellNonLocalPad.h"
#import "BALocation.h"

@implementation BADocumentItemElementCellNonLocalPad

@synthesize locationConnector;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadLocationWithUri:(NSString *)uri {
   [self setLocationConnector:[[BAConnector alloc] init]];
   [self.locationConnector loadLocationForUri:uri WithDelegate:self];
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result {
   BALocation *tempLocation = (BALocation *)result;
   if (![tempLocation.shortname isEqualToString:@""]) {
      [self.title setText:tempLocation.shortname];
   } else {
      [self.title setText:tempLocation.name];
   }
}

- (void)prepareForReuse {
   [self.locationConnector.currentConnection cancel];
}

- (void)commandIsNotInScope:(NSString *)command {
   // ToDo: reset state if necessary
}

- (void)networkIsNotReachable:(NSString *)command {
   // ToDo: reset state if necessary
}

@end
