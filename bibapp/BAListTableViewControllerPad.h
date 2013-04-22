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
#import "BADocument.h"
#import "BAConnectorDelegate.h"
#import "BALocation.h"
#import "BATocTableViewControllerPad.h"

@interface BAListTableViewControllerPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UIPopoverControllerDelegate, BAConnectorDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) NSArray *dummyBooksMerkliste;
@property NSInteger position;
@property (strong, nonatomic) BAEntryWork *currentItem;
@property (strong, nonatomic) BAEntryWork *currentEntry;
@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *trashIcon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *isbdLabel;
@property (weak, nonatomic) IBOutlet UIButton *tocButton;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *tocTitleButton;
@property (strong, nonatomic) UITextView *defaultTextView;
@property (strong, nonatomic) UIImageView *defaultImageView;
@property (strong, nonatomic) BADocument *currentDocument;
@property BOOL didLoadISBD;
@property float computedSizeOfTitleCell;
@property (strong, nonatomic) UIImage *cover;
@property BOOL searchedForCover;
@property BOOL foundCover;
@property (weak, nonatomic) IBOutlet UINavigationBar *listNavigationBar;
@property (weak, nonatomic) IBOutlet UINavigationBar *detailNavigationBar;
@property (strong, nonatomic) BALocation *currentLocation;
@property (strong, nonatomic) UIPopoverController *tocPopoverController;
@property (strong, nonatomic) BATocTableViewControllerPad *tocTableViewController;
@property (weak, nonatomic) IBOutlet UIButton *loanButton;
@property (weak, nonatomic) IBOutlet UIButton *loanTitleButton;

- (IBAction)trashAction:(id)sender;

@end
