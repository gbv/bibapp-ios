//
//  BAListTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"
#import "BAEntryWork.h"
#import "BADetailScrollViewDelegate.h"

@interface BAListTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, BADetailScrollViewDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *dummyBooksMerkliste;
@property NSInteger position;
@property (strong, nonatomic) BAEntryWork *currentItem;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashIcon;
@property BOOL didReturnFromDetail;

- (IBAction)trashAction:(id)sender;

@end
