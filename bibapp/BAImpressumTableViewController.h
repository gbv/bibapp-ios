//
//  BAImpressumTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 19.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"

@interface BAImpressumTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;

@end
