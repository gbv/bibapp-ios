//
//  BASearchTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"
#import "BAEntryWork.h"
#import "BAEntry.h"
#import "BAConnectorDelegate.h"
#import "BADetailScrollViewDelegate.h"

@interface BASearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, BAConnectorDelegate, BADetailScrollViewDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (strong, nonatomic) NSMutableArray *booksLocal;
@property (strong, nonatomic) NSMutableArray *booksGVK;
@property (weak, nonatomic) BAEntryWork *currentEntry;
@property NSInteger positionLocal;
@property NSInteger position;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentedController;
@property (strong, nonatomic) NSString *lastSearchLocal;
@property (strong, nonatomic) NSString *lastSearch;
@property BOOL searchedLocal;
@property BOOL searched;
@property BOOL isSearching;
@property BOOL lastSearchNoResultsLocal;
@property BOOL lastSearchNoResults;
@property NSInteger searchCountLocal;
@property NSInteger searchCount;
@property (strong, nonatomic) NSArray *picaParameters;
@property NSInteger currentPicaParameterIndex;

- (void) continueSearchFor:(NSString *)catalog;
- (void) continueSearch;
- (void) updatePosition:(long)updatePosition;

@end
