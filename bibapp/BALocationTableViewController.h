//
//  BALocationTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 07.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"
#import "BAConnectorDelegate.h"
#import "BALocation.h"

@interface BALocationTableViewController : UITableViewController <BAConnectorDelegate>

@property (strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *locationList;
@property (strong, nonatomic) BALocation *currentLocation;
@property BOOL didReturnFromSegue;
@property BOOL foundLocations;

@end
