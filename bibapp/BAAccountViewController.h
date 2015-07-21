//
//  BAAccountViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"
#import "BAAccount.h"
#import "BAConnectorDelegate.h"

@interface BAAccountViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate, UIActionSheetDelegate, BAConnectorDelegate>

@property (strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *loan;
@property (strong, nonatomic) NSMutableArray *reservation;
@property (strong, nonatomic) NSMutableArray *interloan;
@property (strong, nonatomic) NSMutableArray *feesSum;
@property (strong, nonatomic) NSMutableArray *fees;
@property (strong, nonatomic) NSMutableArray *sendEntries;
@property (strong, nonatomic) NSMutableArray *successfulEntriesWrapper;
@property (strong, nonatomic) NSMutableDictionary *successfulEntries;
@property (strong, nonatomic) NSString *currentAccount;
@property (strong, nonatomic) NSString *currentPassword;
@property (strong, nonatomic) NSString *currentToken;
@property (strong, nonatomic) NSArray *currentScope;
@property BOOL isLoggingIn;
//@property BOOL loggedIn;
@property (strong, nonatomic) IBOutlet UITableView *accountTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *accountSegmentedController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

- (IBAction)actionButtonAction:(id)sender;

@end
