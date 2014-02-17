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
#import "BALocation.h"

@interface BAInfoViewControllerPad : UIViewController <UITableViewDataSource, UITableViewDelegate, BAConnectorDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UINavigationBar *infoNavigationBar;
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) NSMutableArray *infoFeed;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;
@property (strong, nonatomic) NSMutableArray *locationList;
@property (strong, nonatomic) BALocation *currentLocation;
@property (weak, nonatomic) IBOutlet UIView *statusBarTintUIView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *optionsButton;

@end
