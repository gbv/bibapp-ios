//
//  BADetailViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "BAAppDelegate.h"
#import "BASearchViewController.h"
#import "BAEntryWork.h"
#import "BAEntry.h"
#import "BAConnectorDelegate.h"
#import "BADocument.h"
#import "BALocation.h"
#import "BADetailScrollViewController.h"

@interface BADetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate, BAConnectorDelegate>

@property (strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) BASearchViewController *searchController;
@property (strong, nonatomic) NSMutableArray *bookList;
@property NSInteger position;
@property (strong, nonatomic) BAEntryWork *currentEntry;
@property (strong, nonatomic) BADocument *currentDocument;
@property (strong, nonatomic) BALocation *currentLocation;
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) UIImage *cover;
@property BOOL searchedForCover;
@property BOOL foundCover;
@property (strong, nonatomic) NSString *toc;
@property BOOL foundPDFToc;
@property BOOL didLoadISBD;
@property BOOL didReturnFromSegue;
@property float computedSizeOfTitleCell;
@property CGRect frame;
@property (strong, nonatomic) BADetailScrollViewController *scrollViewController;
@property BOOL searchedCoverByISBN;
@property BOOL didCheckBlockOrderTypes;
@property BOOL blockOrderByTypes;
@property long currentDaiaFamIndex;

- (void)actionButton;
- (void)initDetailView;
- (id)initWithFrame:(CGRect)frame;
- (BOOL)entryOnList;

@end
