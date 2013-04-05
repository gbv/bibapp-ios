//
//  BAInfoTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 28.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"
#import "BAConnectorDelegate.h"

@interface BAInfoTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, BAConnectorDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) NSMutableArray *infoFeed;

@end
