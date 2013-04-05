//
//  BASearchViewControllerPad.h
//  bibapp
//
//  Created by Johannes Schultze on 18.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"
#import "BAEntryWork.h"
#import "BAConnectorDelegate.h"
#import "BADocument.h"
#import "BALocation.h"
#import "BATocTableViewControllerPad.h"

@interface BASearchViewControllerPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, UIPopoverControllerDelegate, BAConnectorDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *booksLocal;
@property (strong, nonatomic) NSMutableArray *booksGVK;
@property (weak, nonatomic) BAEntryWork *currentEntryLocal;
@property (weak, nonatomic) BAEntryWork *currentEntry;
@property NSInteger positionLocal;
@property NSInteger position;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentedController;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarSearch;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBarDetail;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *isbdLabel;
@property (weak, nonatomic) IBOutlet UIButton *tocButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UIButton *tocTitleButton;
@property (strong, nonatomic) NSString *lastSearchLocal;
@property (strong, nonatomic) NSString *lastSearch;
@property BOOL searchedLocal;
@property BOOL searched;
@property NSInteger searchCountLocal;
@property NSInteger searchCount;
@property (strong, nonatomic) UITextView *defaultTextView;
@property (strong, nonatomic) UIImageView *defaultImageView;
@property (strong, nonatomic) BADocument *currentDocument;
@property BOOL didLoadISBD;
@property float computedSizeOfTitleCell;
@property (strong, nonatomic) UIImage *cover;
@property BOOL searchedForCover;
@property BOOL foundCover;
@property (strong, nonatomic) BALocation *currentLocation;
@property (strong, nonatomic) UIPopoverController *tocPopoverController;
@property (strong, nonatomic) BATocTableViewControllerPad *tocTableViewController;
@property BOOL initialSearchLocal;
@property BOOL initialSearch;

- (IBAction)listAction:(id)sender;

- (void) continueSearchFor:(NSString *)catalog;

@end
