//
//  BASearchViewControllerPad.m
//  bibapp
//
//  Created by Johannes Schultze on 18.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BASearchViewControllerPad.h"
#import "BAItemCell.h"
#import "BAConnector.h"
#import "BADocumentItem.h"
#import "BADocumentItemElement.h"
#import "BAItemDetail.h"
#import "BADocumentItemElementCellPad.h"
#import "BADocumentItemElementCellNonLocalPad.h"
#import "BALocationViewControllerPad.h"
#import "BACoverViewControllerPad.h"
#import "BAEntry.h"
#import "BATocViewControllerPad.h"
#import "BANoSearchResultsCell.h"
#import "DAIAParser.h"
#import "BALocalizeHelper.h"

#import "GDataXMLNode.h"

@interface BASearchViewControllerPad ()

@end

@implementation BASearchViewControllerPad

@synthesize booksLocal;
@synthesize booksGVK;
@synthesize currentEntryLocal;
@synthesize currentEntry;
@synthesize positionLocal;
@synthesize position;
@synthesize searchBar;
@synthesize searchSegmentedController;
@synthesize lastSearchLocal;
@synthesize lastSearch;
@synthesize searchedLocal;
@synthesize searched;
@synthesize searchCountLocal;
@synthesize searchCount;
@synthesize defaultTextView;
@synthesize defaultImageView;
@synthesize currentDocument;
@synthesize didLoadISBD;
@synthesize computedSizeOfTitleCell;
@synthesize cover;
@synthesize searchedForCover;
@synthesize foundCover;
@synthesize currentLocation;
@synthesize tocPopoverController;
@synthesize tocTableViewController;
@synthesize initialSearchLocal;
@synthesize initialSearch;
@synthesize statusBarTintUIView;
@synthesize lastSearchNoResultsLocal;
@synthesize lastSearchNoResults;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // http://stackoverflow.com/a/19106407
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   
	 // Do any additional setup after loading the view.
   
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCatalogue:) name:@"changeCatalogue" object:nil];
    
    [self.navigationBarSearch setTintColor:self.appDelegate.configuration.currentBibTintColor];
    [self.navigationBarDetail setTintColor:self.appDelegate.configuration.currentBibTintColor];
    [self.searchBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    if (self.appDelegate.isIOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
        //[self.statusBarTintUIView setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.navigationBarSearch setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.navigationBarDetail setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.searchSegmentedController setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
        [self.searchSegmentedController setTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.optionsButton setTintColor:[UIColor whiteColor]];
        //[self.optionsButton setEnabled:YES];
    } else {
        [self.statusBarTintUIView setHidden:YES];
        [self.searchSegmentedController setTintColor:self.appDelegate.configuration.currentBibTintColor];
    }
    
    [self.searchSegmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.searchSegmentedController setTitle:[self.appDelegate.configuration getTitleForCatalog:self.appDelegate.options.selectedCatalogue] forSegmentAtIndex:0];
    
    [self.searchBar setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
    self.searchBar.delegate = self;
    
    [self.tabBarItem setTitle:self.appDelegate.configuration.searchTitle];
    
    self.lastSearchLocal = @"";
    self.lastSearch = @"";
    
    self.defaultTextView = [[UITextView alloc] initWithFrame:CGRectMake(320, 139, 704, 75)];
    [self.defaultTextView setFont:[UIFont systemFontOfSize:20]];
    [self.defaultTextView setTextAlignment:NSTextAlignmentCenter];
    [self.defaultTextView setEditable:NO];
    [self.defaultTextView setUserInteractionEnabled:NO];
    [self.defaultTextView setOpaque:YES];
    [self.defaultTextView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.defaultTextView];
    
    self.defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(547, 214, 250, 150)];
    [self.defaultImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.defaultImageView setImage:[UIImage imageNamed:@"Buch_250_gradient.png"]];
    [self.view addSubview:self.defaultImageView];
    
    [self.searchTableView setTag:0];
    [self.detailTableView setTag:1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [tap setDelegate:self];
    [self.coverView addGestureRecognizer:tap];
    
    [self initDetailView];
    
    self.tocTableViewController = [[BATocTableViewControllerPad alloc] init];
    [self.tocTableViewController setSearchController:self];
    
    [self setInitialSearchLocal:YES];
    [self setInitialSearch:YES];
    
    self.picaParameters = [NSArray arrayWithObjects:@"pica.bbg", @"pica.mak", nil];
    self.currentPicaParameterIndex = 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchTableView setFrame:CGRectMake(0, 117, 320, 582)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView.tag == 0) {
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
           if ([self.booksLocal count] > 0) {
              return [self.booksLocal count];
           } else if (self.searchedLocal) {
              return 1;
           } else {
              return 0;
           }
        } else {
           if ([self.booksGVK count] > 0) {
              return [self.booksGVK count];
           } else if (self.searched) {
              return 1;
           } else {
              return 0;
           }
        }
    } else if (tableView.tag == 1) {
        return [self.currentDocument.items count];
    } else {
        return 0;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.searchSegmentedController setTitle:[self.appDelegate.configuration getTitleForCatalog:self.appDelegate.options.selectedCatalogue] forSegmentAtIndex:0];
    [self.searchTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag == 0) {
        if ([self.searchSegmentedController selectedSegmentIndex] == 0 && [self.booksLocal count] == 0 && self.searchedLocal) {
           self.lastSearchNoResultsLocal = YES;
           BANoSearchResultsCell *cell = (BANoSearchResultsCell *) [tableView dequeueReusableCellWithIdentifier:@"BANoSearchResultsCell"];
           if (cell == nil) {
              NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BANoSearchResultsCell" owner:self options:nil];
              cell = [nib objectAtIndex:0];
           }
           [cell.textView setText:[[NSString alloc] initWithFormat:BALocalizedString(@"Ihre Suche nach \"%@\" hat keine Treffer ergeben."), self.lastSearchLocal]];
           [cell.searchGBVButton addTarget:self action:@selector(searchGBV) forControlEvents:UIControlEventTouchUpInside];
           return cell;
        }
       
        if ([self.searchSegmentedController selectedSegmentIndex] == 1 && [self.booksGVK count] == 0 && self.searched) {
           self.lastSearchNoResults = YES;
           BANoSearchResultsCell *cell = (BANoSearchResultsCell *) [tableView dequeueReusableCellWithIdentifier:@"BANoSearchResultsCell"];
           if (cell == nil) {
              NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BANoSearchResultsCell" owner:self options:nil];
              cell = [nib objectAtIndex:0];
           }
           [cell.textView setText:[[NSString alloc] initWithFormat:BALocalizedString(@"Ihre Suche nach \"%@\" hat keine Treffer ergeben."), self.lastSearch]];
           [cell.searchGBVButton setHidden:YES];
           return cell;
        }
       
        BAItemCell *tempCell = (BAItemCell *) [tableView dequeueReusableCellWithIdentifier:@"BAItemCell"];
        if (tempCell == nil) {
           NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAItemCell" owner:self options:nil];
           tempCell = [nib objectAtIndex:0];
        }
       
        // Configure the cell...
        BAEntryWork *entry;
        
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            entry = [self.booksLocal objectAtIndex:indexPath.row];
            if (indexPath.row == ([self.booksLocal count]-1)) {
                if (self.searchCountLocal-1 > indexPath.row) {
                    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    [spinner startAnimating];
                    spinner.frame = CGRectMake(0, 0, 320, 44);
                    self.searchTableView.tableFooterView = spinner;
                    [self continueSearchFor:@"local"];
                }
            }
        } else if ([self.searchSegmentedController selectedSegmentIndex] == 1) {
            entry = [self.booksGVK objectAtIndex:indexPath.row];
            if (indexPath.row == ([self.booksGVK count])-1) {
                if (self.searchCount-1 > indexPath.row) {
                    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                    [spinner startAnimating];
                    spinner.frame = CGRectMake(0, 0, 320, 44);
                    self.searchTableView.tableFooterView = spinner;
                    [self continueSearchFor:@"nonLocal"];
                }
            }
        }
        [tempCell.titleLabel setText:entry.title];
        [tempCell.subtitleLabel setText:entry.subtitle];
        [tempCell.image setImage:[entry mediaIcon]];
        [tempCell.authorLabel setText:entry.author];
        [tempCell.yearLabel setText:entry.year];
        cell = tempCell;
    } else if (tableView.tag == 1) {
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            BADocumentItemElementCellPad *cell = (BADocumentItemElementCellPad *) [tableView dequeueReusableCellWithIdentifier:@"BADocumentItemElementCellPad"];
            if (cell == nil) {
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BADocumentItemElementCellPad" owner:self options:nil];
               cell = [nib objectAtIndex:0];
            }
           
            BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:[indexPath row]];
            
            if (self.currentEntryLocal.onlineLocation == nil) {
                NSMutableString *titleString = [[NSMutableString alloc] init];
                if (tempDocumentItem.department != nil && !self.appDelegate.configuration.currentBibHideDepartment) {
                    [titleString appendString:tempDocumentItem.department];
                }
                if (tempDocumentItem.storage != nil) {
                    if (![tempDocumentItem.storage isEqualToString:@""]) {
                        if (!self.appDelegate.configuration.currentBibHideDepartment) {
                            [titleString appendFormat:@", %@", tempDocumentItem.storage];
                        } else {
                            [titleString appendFormat:@"%@", tempDocumentItem.storage];
                        }
                    }
                } else {
                    if (tempDocumentItem.department != nil && [titleString isEqualToString:@""]) {
                        [titleString appendString:tempDocumentItem.department];
                    }
                }
                [cell.title setText:titleString];
            } else {
                [cell.title setText:self.currentEntryLocal.onlineLocation];
            }
            [cell.subtitle setText:tempDocumentItem.label];
            
            NSMutableString *status = [[NSMutableString alloc] init];
            NSMutableString *statusInfo = [[NSMutableString alloc] init];
            
            BADocumentItemElement *presentation;
            BADocumentItemElement *loan;
            
            for (BADocumentItemElement *element in tempDocumentItem.services) {
                if ([element.service isEqualToString:@"presentation"]) {
                    presentation = element;
                } else if ([element.service isEqualToString:@"loan"]) {
                    loan = element;
                }
            }
           
            [cell.status setTextColor:[[UIColor alloc] initWithRed:0.474510F green:0.474510F blue:0.474510F alpha:1.0F]];
            
            bool foundBarcode = YES;
            if (loan.available) {
                [cell.status setTextColor:[[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
                [status appendString:BALocalizedString(@"ausleihbar")];
                
                if (presentation.limitation != nil) {
                    [status appendString:[[NSString alloc] initWithFormat:@"; %@", presentation.limitation]];
                }
                
                if (presentation.available) {
                    if (loan.href == nil) {
                        [statusInfo appendString:BALocalizedString(@"Bitte am Standort entnehmen")];
                    } else {
                        [statusInfo appendString:BALocalizedString(@"Bitte bestellen")];
                        NSURL *loanHref = [[NSURL alloc] initWithString:loan.href];
                        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:loanHref resolvingAgainstBaseURL:NO];
                        for (NSURLQueryItem *queryItem in urlComponents.queryItems) {
                            if ([queryItem.name isEqualToString:@"bar"] && [queryItem.value isEqualToString:@""]) {
                                foundBarcode = NO;
                            }
                        }
                    }
                }
            } else {
                if (loan.href != nil) {
                    NSRange match = [loan.href rangeOfString: @"loan/RES"];
                    if (match.length > 0) {
                        [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
                        [status appendString:BALocalizedString(@"ausleihbar")];
                    } else {
                        [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.00 alpha:1.0]];
                        [status appendString:BALocalizedString(@"nicht ausleihbar")];
                    }
                } else {
                    if (self.currentEntryLocal.onlineLocation == nil) {
                        [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.00 alpha:1.0]];
                        [status appendString:BALocalizedString(@"nicht ausleihbar")];
                    } else {
                        [status appendString:BALocalizedString(@"Online-Ressource im Browser öffnen")];
                    }
                }
                if (presentation.limitation != nil) {
                    [status appendString:[[NSString alloc] initWithFormat:@"; %@", presentation.limitation]];
                }
                
                if (!presentation.available) {
                    if (loan.href == nil) {
                        //[statusInfo appendString:@"..."];
                    } else {
                        NSRange match = [loan.href rangeOfString: @"loan/RES"];
                        if (match.length > 0) {
                            if ([loan.expected isEqualToString:@""] || [loan.expected isEqualToString:@"unknown"]) {
                                [statusInfo appendString:BALocalizedString(@"ausgeliehen, Vormerken möglich")];
                            } else {
                                NSString *year = [loan.expected substringWithRange: NSMakeRange (0, 4)];
                                NSString *month = [loan.expected substringWithRange: NSMakeRange (5, 2)];
                                NSString *day = [loan.expected substringWithRange: NSMakeRange (8, 2)];
                                [statusInfo appendString:[[NSString alloc] initWithFormat:BALocalizedString(@"ausgeliehen bis %@.%@.%@, Vormerken möglich"), day, month, year]];
                            }
                        }
                    }
                } else {
                    NSRange match = [presentation.href rangeOfString: @"action=order"];
                    if (match.length > 0) {
                        [statusInfo appendString:BALocalizedString(@"Vor Ort benutzbar, bitte bestellen")];
                    }
                }
            }
           
            if (tempDocumentItem.daiaInfoFromOpac) {
               status = [[NSMutableString alloc] initWithFormat:@"%@", self.appDelegate.configuration.currentBibDaiaInfoFromOpacDisplay];
            }
           
            if (!foundBarcode) {
                status = [BALocalizedString(@"Blockierte Bestellung") mutableCopy];
                statusInfo = [BALocalizedString(@"Blockierte Bestellung Info") mutableCopy];
                [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.00 alpha:1.0]];
                [cell.statusInfo setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.00 alpha:1.0]];
                tempDocumentItem.blockOrder = YES;
            }
            
            [cell.status setText:status];
            [cell.statusInfo setText:statusInfo];
            [cell.actionButton setTag:indexPath.row];
            [cell.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            //[self activateActionButton:cell.actionButton];
            
            if (indexPath.row % 2) {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.title.backgroundColor = [UIColor whiteColor];
                cell.subtitle.backgroundColor = [UIColor whiteColor];
                cell.status.backgroundColor = [UIColor whiteColor];
                cell.statusInfo.backgroundColor = [UIColor whiteColor];
            } else {
                cell.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.title.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.subtitle.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.status.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.statusInfo.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            }
            
            cell.tag = indexPath.row;
            
            return cell;
        } else {
            BADocumentItemElementCellNonLocalPad *cell = (BADocumentItemElementCellNonLocalPad *) [tableView dequeueReusableCellWithIdentifier:@"BADocumentItemElementCellNonLocalPad"];
            if (cell == nil) {
               NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BADocumentItemElementCellNonLocalPad" owner:self options:nil];
               cell = [nib objectAtIndex:0];
            }
           
            BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:[indexPath row]];
            [cell.title setText:tempDocumentItem.department];
            [cell.labels setText:tempDocumentItem.label];
            [cell.actionButton setTag:indexPath.row];
            [cell.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell loadLocationWithUri:tempDocumentItem.uri];
            //[self activateActionButton:cell.actionButton];
            if (indexPath.row % 2) {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.title.backgroundColor = [UIColor whiteColor];
                cell.labels.backgroundColor = [UIColor whiteColor];
            } else {
                cell.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.title.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.labels.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            }
            return cell;
        }
    }
    return cell;
}

- (void)continueSearchFor:(NSString *)catalog{
    if ([catalog isEqualToString:@"local"]) {
        BAConnector *connector = [BAConnector generateConnector];
        //[connector searchLocalFor:self.searchBar.text WithFirst:[self.booksLocal count]+1 WithDelegate:self];
        [connector searchLocalFor:self.searchBar.text WithPicaParameter:[self.picaParameters objectAtIndex:self.currentPicaParameterIndex] WithFirst:[self.booksLocal count]+1 WithDelegate:self];
    } else if ([catalog isEqualToString:@"nonLocal"]) {
        BAConnector *connector = [BAConnector generateConnector];
        [connector searchCentralFor:self.searchBar.text WithFirst:[self.booksGVK count]+1 WithDelegate:self];
    }
}

- (void)searchBarSearchButtonClicked
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.searchTableView.tableFooterView = spinner;
    [self.searchTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        self.lastSearchLocal = self.searchBar.text;
        self.searchCountLocal = 0;
        self.initialSearchLocal = YES;
        self.booksLocal = [[NSMutableArray alloc] init];
        BAConnector *connector = [BAConnector generateConnector];
        //[connector searchLocalFor:self.searchBar.text WithFirst:1 WithDelegate:self];
        [connector searchLocalFor:self.searchBar.text WithPicaParameter:[self.picaParameters objectAtIndex:self.currentPicaParameterIndex] WithFirst:1 WithDelegate:self];
    } else {
        self.lastSearch = self.searchBar.text;
        self.searchCount = 0;
        self.initialSearch = YES;
        self.booksGVK = [[NSMutableArray alloc] init];
        BAConnector *connector = [BAConnector generateConnector];
        [connector searchCentralFor:self.searchBar.text WithFirst:1 WithDelegate:self];
    }
    [self.searchTableView reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self searchBarSearchButtonClicked];
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
    if ([command isEqualToString:@"searchLocal"] || [command isEqualToString:@"searchCentral"]) {
        BOOL retrySearchWithNextParameter = NO;
        
        GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
        
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        NSArray *setArray = [parser nodesForXPath:@"/zs:searchRetrieveResponse/zs:numberOfRecords" error:nil];
        if ([setArray count] > 0) {
            GDataXMLElement *set = [setArray objectAtIndex:0];
            /*if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
                self.searchCountLocal = [[set stringValue] integerValue];
            } else {
                self.searchCount = [[set stringValue] integerValue];
            }*/
            if ([command isEqualToString:@"searchLocal"]) {
                self.searchCountLocal = [[set stringValue] integerValue];
            } else if ([command isEqualToString:@"searchCentral"]) {
                self.searchCount = [[set stringValue] integerValue];
            }
        } else {
            if (!self.searchedLocal) {
                if ([self.picaParameters count] > (self.currentPicaParameterIndex+1)) {
                    retrySearchWithNextParameter = YES;
                    self.currentPicaParameterIndex++;
                    [self searchBarSearchButtonClicked];
                }
            }
        }
        
        /*if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            [self.navigationBarSearch.topItem setTitle:[[NSString alloc] initWithFormat:@"Lokale Suche (%d Treffer)", self.searchCountLocal]];
            self.searchedLocal = YES;
        } else {
            [self.navigationBarSearch.topItem setTitle:[[NSString alloc] initWithFormat:@"GVK Suche (%d Treffer)", self.searchCount]];
            self.searched = YES;
        }*/
        
        if (!retrySearchWithNextParameter) {
            if ([command isEqualToString:@"searchLocal"]) {
                if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
                    [self.navigationBarSearch.topItem setTitle:[[NSString alloc] initWithFormat:BALocalizedString(@"Lokale Suche (%ld Treffer)"), (long)self.searchCountLocal]];
                }
                self.searchedLocal = YES;
            } else if ([command isEqualToString:@"searchCentral"]) {
                if ([self.searchSegmentedController selectedSegmentIndex] == 1) {
                    [self.navigationBarSearch.topItem setTitle:[[NSString alloc] initWithFormat:BALocalizedString(@"GVK Suche (%ld Treffer)"), (long)self.searchCount]];
                }
                self.searched = YES;
            }
            
            NSArray *shorttitles = [parser nodesForXPath:@"/zs:searchRetrieveResponse/zs:records/zs:record" error:nil];
            
            for (GDataXMLElement *shorttitle in shorttitles) {
                
                GDataXMLElement *shortTitleNew = (GDataXMLElement *)[[(GDataXMLElement *)[[shorttitle elementsForName:@"zs:recordData"] objectAtIndex:0] elementsForName:@"mods"] objectAtIndex:0];
                
                BAEntryWork *tempEntry = [[BAEntryWork alloc] init];
                [tempEntry setTocArray:[[NSMutableArray alloc] init]];
                
                GDataXMLElement *recordInfo = (GDataXMLElement *)[[shortTitleNew elementsForName:@"recordInfo"] objectAtIndex:0];
                
                // PPN "CIANDO731060903" -> "731060903"
                NSString *tempPpn = [(GDataXMLElement *)[[recordInfo elementsForName:@"recordIdentifier"] objectAtIndex:0] stringValue];
                tempPpn = [tempPpn stringByReplacingOccurrencesOfString:@"CIANDO" withString:@""];
                [tempEntry setPpn:tempPpn];
                
                [tempEntry setIsbn:@""];
                GDataXMLElement *tempISBNElement = (GDataXMLElement *)[[shortTitleNew elementsForName:@"identifier"] objectAtIndex:0];
                if (tempISBNElement != nil) {
                    NSRange rangeValue = [[[tempISBNElement attributeForName:@"type"] stringValue] rangeOfString:@"isbn" options:NSCaseInsensitiveSearch];
                    if (rangeValue.length > 0) {
                        NSRegularExpression *regexLine = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+)" options:NSRegularExpressionCaseInsensitive error:nil];
                        NSArray *resultsISBN = [regexLine matchesInString:[tempISBNElement stringValue] options:0 range:NSMakeRange(0, [[tempISBNElement stringValue] length])];
                        if ([resultsISBN count] > 0) {
                            for (NSTextCheckingResult *match in resultsISBN) {
                                NSRange matchRange = [match rangeAtIndex:1];
                                [tempEntry setIsbn:[[tempISBNElement stringValue] substringWithRange:matchRange]];
                            }
                        }
                    }
                }
                
                [tempEntry setMatstring:[(GDataXMLElement *)[[shortTitleNew elementsForName:@"typeOfResource"] objectAtIndex:0] stringValue]];
                [tempEntry setMediaIconTypeOfResource:[(GDataXMLElement *)[[shortTitleNew elementsForName:@"typeOfResource"] objectAtIndex:0] stringValue]];
                
                /*if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
                    [tempEntry setLocal:YES];
                } else {
                    [tempEntry setLocal:NO];
                }*/
                if ([command isEqualToString:@"searchLocal"]) {
                    [tempEntry setLocal:YES];
                } else if ([command isEqualToString:@"searchCentral"]) {
                    [tempEntry setLocal:NO];
                }
                
                GDataXMLElement *titleInfo = (GDataXMLElement *)[[shortTitleNew elementsForName:@"titleInfo"] objectAtIndex:0];
                NSString *tempTitleNonSort = [(GDataXMLElement *)[[titleInfo elementsForName:@"nonSort"] objectAtIndex:0] stringValue];
                if (tempTitleNonSort == nil) {
                    tempTitleNonSort = @"";
                }
                
                NSString *tempTitle = [(GDataXMLElement *)[[titleInfo elementsForName:@"title"] objectAtIndex:0] stringValue];
                [tempEntry setTitle:[[NSString alloc] initWithFormat:@"%@%@", tempTitleNonSort, tempTitle]];
                
                NSMutableString *tempCombinedSubTitle = [[NSMutableString alloc] initWithString:@""];
                
                NSString *tempTitlePartNumber = [(GDataXMLElement *)[[titleInfo elementsForName:@"partNumber"] objectAtIndex:0] stringValue];
                if (tempTitlePartNumber != nil) {
                    [tempEntry setPartNumber:tempTitlePartNumber];
                    [tempCombinedSubTitle appendString:tempTitlePartNumber];
                }
                
                NSString *tempTitlePartName = [(GDataXMLElement *)[[titleInfo elementsForName:@"partName"] objectAtIndex:0] stringValue];
                if (tempTitlePartName != nil) {
                    [tempEntry setPartName:tempTitlePartName];
                    if (![tempCombinedSubTitle isEqualToString:@""]) {
                        [tempCombinedSubTitle appendString:@"; "];
                    }
                    [tempCombinedSubTitle appendString:tempTitlePartName];
                }
                
                NSString *tempSubTitle = [(GDataXMLElement *)[[titleInfo elementsForName:@"subTitle"] objectAtIndex:0] stringValue];
                if (tempSubTitle != nil) {
                    if (![tempCombinedSubTitle isEqualToString:@""]) {
                        [tempCombinedSubTitle appendString:@"; "];
                    }
                    [tempCombinedSubTitle appendString:tempSubTitle];
                }
                
                [tempEntry setSubtitle:tempCombinedSubTitle];
                
                NSArray *names = [shortTitleNew elementsForName:@"name"];
                if ([names count] > 0) {
                    NSMutableString *authorString = [[NSMutableString alloc] init];
                    BOOL first = YES;
                    for (GDataXMLElement *tempNamesElement in names) {
                        NSArray *tempNames = [tempNamesElement elementsForName:@"namePart"];
                        GDataXMLElement *family;
                        GDataXMLElement *given;
                        for (GDataXMLElement *namePart in tempNames) {
                            if ([[[namePart attributeForName:@"type"] stringValue] isEqualToString:@"family"]) {
                                family = namePart;
                            } else if ([[[namePart attributeForName:@"type"] stringValue] isEqualToString:@"given"]) {
                                given = namePart;
                            }
                        }
                        if (!first) {
                            if (![authorString isEqualToString:@""]) {
                                [authorString appendString:@", "];
                            }
                        } else {
                            first = NO;
                        }
                        if (given != nil) {
                            [authorString appendFormat:@"%@", given.stringValue];
                        }
                        if (family != nil) {
                            [authorString appendFormat:@" %@", family.stringValue];
                        }
                    }
                    [tempEntry setAuthor:authorString];
                }
                
                // Get additional information to select the correct icon
                
                GDataXMLElement *physicalDescription = (GDataXMLElement *)[[shortTitleNew elementsForName:@"physicalDescription"] objectAtIndex:0];
                if (physicalDescription != nil) {
                    NSArray *physicalDescriptionForms = [physicalDescription elementsForName:@"form"];
                    for (GDataXMLElement *physicalDescriptionForm in physicalDescriptionForms) {
                        NSRange rangeValue = [[[physicalDescriptionForm attributeForName:@"authority"] stringValue] rangeOfString:@"marc" options:NSCaseInsensitiveSearch];
                        if (rangeValue.length > 0) {
                            if ([[physicalDescriptionForm stringValue] isEqualToString:@"microform"]) {
                                [tempEntry setMediaIconPhysicalDescriptionForm:@"microform"];
                            } else if ([[physicalDescriptionForm stringValue] isEqualToString:@"remote"]) {
                                [tempEntry setMediaIconPhysicalDescriptionForm:@"remote"];
                            }
                        }
                    }
                    NSArray *physicalDescriptionExtents = [physicalDescription elementsForName:@"extent"];
                    for (GDataXMLElement *physicalDescriptionExtent in physicalDescriptionExtents) {
                        NSRange rangeValue = [[physicalDescriptionExtent stringValue] rangeOfString:@"Mikrof" options:NSCaseInsensitiveSearch];
                        if (rangeValue.length > 0) {
                            [tempEntry setMediaIconPhysicalDescriptionForm:@"microform"];
                        }
                    }
                }
                
                GDataXMLElement *typeOfResource = (GDataXMLElement *)[[shortTitleNew elementsForName:@"typeOfResource"] objectAtIndex:0];
                if (typeOfResource != nil) {
                    NSRange rangeValueTypeOfResource = [[[typeOfResource attributeForName:@"manuscript"] stringValue] rangeOfString:@"yes" options:NSCaseInsensitiveSearch];
                    if (rangeValueTypeOfResource.length > 0) {
                        [tempEntry setMediaIconTypeOfResourceManuscript:@"yes"];
                    }
                }
                
                GDataXMLElement *relatedItem = (GDataXMLElement *)[[shortTitleNew elementsForName:@"relatedItem"] objectAtIndex:0];
                if (relatedItem != nil) {
                    NSRange rangeValueType = [[[relatedItem attributeForName:@"type"] stringValue] rangeOfString:@"host" options:NSCaseInsensitiveSearch];
                    if (rangeValueType.length > 0) {
                        [tempEntry setMediaIconRelatedItemType:@"host"];
                        NSRange rangeValueDisplayLabel = [[[relatedItem attributeForName:@"displayLabel"] stringValue] rangeOfString:@"In: " options:NSCaseInsensitiveSearch];
                        if (rangeValueDisplayLabel.length > 0) {
                            [tempEntry setMediaIconDisplayLabel:@"In"];
                        }
                    }
                }
                
                GDataXMLElement *originInfo = (GDataXMLElement *)[[shortTitleNew elementsForName:@"originInfo"] objectAtIndex:0];
                if (originInfo != nil) {
                    GDataXMLElement *issuance = (GDataXMLElement *)[[originInfo elementsForName:@"issuance"] objectAtIndex:0];
                    if (issuance != nil) {
                        [tempEntry setMediaIconOriginInfoIssuance:[issuance stringValue]];
                    }
                    GDataXMLElement *dateIssued = (GDataXMLElement *)[[originInfo elementsForName:@"dateIssued"] objectAtIndex:0];
                    if (dateIssued != nil) {
                       [tempEntry setYear:[dateIssued stringValue]];
                    }
                }
                
                // Get link for online location
                NSArray *onlineLocations = [shortTitleNew elementsForName:@"location"];
                for (GDataXMLElement *onlineLocation in onlineLocations) {
                   if (onlineLocation != nil) {
                      GDataXMLElement *onlineLocationUrl = (GDataXMLElement *)[[onlineLocation elementsForName:@"url"] objectAtIndex:0];
                      if (onlineLocationUrl != nil) {
                         NSRange rangeValueType = [[[onlineLocationUrl attributeForName:@"usage"] stringValue] rangeOfString:@"primary display" options:NSCaseInsensitiveSearch];
                         if (rangeValueType.length > 0) {
                            [tempEntry setOnlineLocation:[onlineLocationUrl stringValue]];
                         }
                      }
                   }
               }
               
                // Get Link table of contents
                GDataXMLElement *relatedItemToc = (GDataXMLElement *)[[shortTitleNew elementsForName:@"relatedItem"] objectAtIndex:0];
                if (relatedItemToc != nil) {
                    NSArray *locationsToc = [relatedItemToc elementsForName:@"location"];
                    if (locationsToc != nil) {
                        for (GDataXMLElement *locationToc in locationsToc) {
                            GDataXMLElement *urlToc = (GDataXMLElement *)[[locationToc elementsForName:@"url"] objectAtIndex:0];
                            if (urlToc != nil) {
                                [tempEntry.tocArray addObject:[urlToc stringValue]];
                            }
                        }
                    }
                }
                
                [tempArray addObject:tempEntry];
            }
            /*if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
                [self.booksLocal addObjectsFromArray:tempArray];
                if ([tempArray count] > 0) {
                    //self.currentEntryLocal = [tempArray objectAtIndex:0];
                    //self.positionLocal = 0;
                }
            } else {
                [self.booksGVK addObjectsFromArray:tempArray];
                if ([tempArray count] > 0) {
                    //self.currentEntry = [tempArray objectAtIndex:0];
                    //self.position = 0;
                }
            }*/
            if ([command isEqualToString:@"searchLocal"]) {
                [self.booksLocal addObjectsFromArray:tempArray];
            } else if ([command isEqualToString:@"searchCentral"]) {
                [self.booksGVK addObjectsFromArray:tempArray];
            }
            [self.searchTableView reloadData];
            
            /*if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
                if(self.initialSearchLocal){
                    if ([tempArray count] > 0) {
                        self.currentEntryLocal = [tempArray objectAtIndex:0];
                        self.positionLocal = 0;
                    }
                    [self showDetailView];
                    [self setInitialSearchLocal:NO];
                }
                [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.positionLocal inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            } else {
                if(self.initialSearch){
                    if ([tempArray count] > 0) {
                        self.currentEntry = [tempArray objectAtIndex:0];
                        self.position = 0;
                    }
                    [self showDetailView];
                    [self setInitialSearch:NO];
                }
                [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.position inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }*/
            if ([command isEqualToString:@"searchLocal"]) {
                if(self.initialSearchLocal){
                    if ([tempArray count] > 0) {
                        self.currentEntryLocal = [tempArray objectAtIndex:0];
                        self.positionLocal = 0;
                    }
                    [self showDetailView];
                    [self setInitialSearchLocal:NO];
                }
                [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.positionLocal inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            } else if ([command isEqualToString:@"searchCentral"]) {
                if(self.initialSearch){
                    if ([tempArray count] > 0) {
                        self.currentEntry = [tempArray objectAtIndex:0];
                        self.position = 0;
                    }
                    [self showDetailView];
                    [self setInitialSearch:NO];
                }
                [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.position inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            self.searchTableView.tableFooterView = nil;
        }
    } else if ([command isEqualToString:@"getDetailsLocal"]) {
       if (!self.appDelegate.configuration.useDAIAParser) {
          [self.currentDocument setItems:[[NSMutableArray alloc] init]];
           GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
           NSArray *document = [parser nodesForXPath:@"_def_ns:daia/_def_ns:document" error:nil];
           if ([document count] > 0) {
               GDataXMLElement *tempDocument = [document objectAtIndex:0];
               [self.currentDocument setDocumentID:[[tempDocument attributeForName:@"id"] stringValue]];
               [self.currentDocument setHref:[[tempDocument attributeForName:@"href"] stringValue]];
           }
           
           NSArray *institution = [parser nodesForXPath:@"_def_ns:daia/_def_ns:institution" error:nil];
           if ([institution count] > 0) {
               GDataXMLElement *tempInstitution = [institution objectAtIndex:0];
               [self.currentDocument setInstitution:[tempInstitution stringValue]];
           }
           
           BAConnector *locationConnector = [BAConnector generateConnector];
           NSArray *items = [parser nodesForXPath:@"_def_ns:daia/_def_ns:document/_def_ns:item" error:nil];
           for (GDataXMLElement *item in items) {
               BADocumentItem *tempDocumentItem = [[BADocumentItem alloc] init];
               [tempDocumentItem setEdition:self.currentDocument.documentID];
               [tempDocumentItem setHref:[[item attributeForName:@"href"] stringValue]];
               [tempDocumentItem setItemID:[[item attributeForName:@"id"] stringValue]];
               
               NSArray *label = [item elementsForName:@"label"];
               if ([label count] == 1) {
                   [tempDocumentItem setLabel:[[label objectAtIndex:0] stringValue]];
               }
               
               NSArray *department = [item elementsForName:@"department"];
               if ([department count] == 1) {
                   [tempDocumentItem setUri:[[[department objectAtIndex:0] attributeForName:@"id"] stringValue]];
                   [tempDocumentItem setLocation:[locationConnector loadLocationForUri:[[[department objectAtIndex:0] attributeForName:@"id"] stringValue]]];
                   if (![tempDocumentItem.location.shortname isEqualToString:@""]) {
                       [tempDocumentItem setDepartment:tempDocumentItem.location.shortname];
                   } else {
                       [tempDocumentItem setDepartment:tempDocumentItem.location.name];
                   }
               }
               
               NSArray *storage = [item elementsForName:@"storage"];
               if ([storage count] == 1) {
                   [tempDocumentItem setStorage:[[storage objectAtIndex:0] stringValue]];
               }
               
               tempDocumentItem.services = [[NSMutableArray alloc] init];
               NSArray *availableItems = [item elementsForName:@"available"];
               for (GDataXMLElement *availableItem in availableItems) {
                   BADocumentItemElement *tempDocumentItemElement = [[BADocumentItemElement alloc] init];
                   [tempDocumentItemElement setAvailable:YES];
                   [tempDocumentItemElement setType:@"available"];
                   [tempDocumentItemElement setHref:[[availableItem attributeForName:@"href"] stringValue]];
                   if ([[[availableItem attributeForName:@"href"] stringValue] isEqualToString:@""] || [[availableItem attributeForName:@"href"] stringValue] == nil) {
                       [tempDocumentItemElement setOrder:NO];
                   } else {
                       [tempDocumentItemElement setOrder:YES];
                   }
                   [tempDocumentItemElement setService:[[availableItem attributeForName:@"service"] stringValue]];
                   [tempDocumentItemElement setDelay:[[availableItem attributeForName:@"delay"] stringValue]];
                   [tempDocumentItemElement setMessage:[[availableItem attributeForName:@"message"] stringValue]];
                   
                   NSArray *limitation = [availableItem elementsForName:@"limitation"];
                   if ([limitation count] == 1) {
                       [tempDocumentItemElement setLimitation:[[limitation objectAtIndex:0] stringValue]];
                   }
                   
                   [tempDocumentItemElement setExpected:[[availableItem attributeForName:@"expected"] stringValue]];
                   [tempDocumentItemElement setQueue:[[availableItem attributeForName:@"queue"] stringValue]];
                   [tempDocumentItem.services addObject:tempDocumentItemElement];
               }
               tempDocumentItem.unavailable = [[NSMutableArray alloc] init];
               NSArray *unavailableItems = [item elementsForName:@"unavailable"];
               for (GDataXMLElement *unavailableItem in unavailableItems) {
                   BADocumentItemElement *tempDocumentItemElement = [[BADocumentItemElement alloc] init];
                   [tempDocumentItemElement setAvailable:NO];
                   [tempDocumentItemElement setType:@"unavailable"];
                   [tempDocumentItemElement setHref:[[unavailableItem attributeForName:@"href"] stringValue]];
                   if ([[[unavailableItem attributeForName:@"href"] stringValue] isEqualToString:@""] || [[unavailableItem attributeForName:@"href"] stringValue] == nil) {
                       [tempDocumentItemElement setOrder:NO];
                   } else {
                       [tempDocumentItemElement setOrder:YES];
                   }
                   [tempDocumentItemElement setService:[[unavailableItem attributeForName:@"service"] stringValue]];
                   [tempDocumentItemElement setDelay:[[unavailableItem attributeForName:@"delay"] stringValue]];
                   [tempDocumentItemElement setMessage:[[unavailableItem attributeForName:@"message"] stringValue]];
                   [tempDocumentItemElement setLimitation:[[unavailableItem attributeForName:@"limitation"] stringValue]];
                   [tempDocumentItemElement setExpected:[[unavailableItem attributeForName:@"expected"] stringValue]];
                   [tempDocumentItemElement setQueue:[[unavailableItem attributeForName:@"queue"] stringValue]];
                   [tempDocumentItem.services addObject:tempDocumentItemElement];
               }
              
               if ([availableItems count] == 0 && [unavailableItems count] == 0) {
                  tempDocumentItem.daiaInfoFromOpac = YES;
               }
              
               [self.currentDocument.items addObject:tempDocumentItem];
           }
       } else {
          DAIAParser *daiaParser = [[DAIAParser alloc] init];
          [daiaParser parseDAIAForDocument:self.currentDocument WithResult:result];
       }
       
        [self.detailTableView reloadData];
        self.detailTableView.tableFooterView = nil;
    } else if ([command isEqualToString:@"getDetails"]) {
       if (!self.appDelegate.configuration.useDAIAParser) {
          [self.currentDocument setItems:[[NSMutableArray alloc] init]];
           GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
           
           NSArray *document = [parser nodesForXPath:@"_def_ns:daia/_def_ns:document" error:nil];
           if ([document count] > 0) {
               GDataXMLElement *tempDocument = [document objectAtIndex:0];
               [self.currentDocument setDocumentID:[[tempDocument attributeForName:@"id"] stringValue]];
               [self.currentDocument setHref:[[tempDocument attributeForName:@"href"] stringValue]];
           }
           
           NSArray *institution = [parser nodesForXPath:@"_def_ns:daia/_def_ns:institution" error:nil];
           if ([institution count] > 0) {
               GDataXMLElement *tempInstitution = [institution objectAtIndex:0];
               [self.currentDocument setInstitution:[tempInstitution stringValue]];
           }
           
           //BAConnector *locationConnector = [BAConnector generateConnector];
           NSArray *items = [parser nodesForXPath:@"_def_ns:daia/_def_ns:document/_def_ns:item" error:nil];
           for (GDataXMLElement *item in items) {
               BADocumentItem *tempDocumentItem = [[BADocumentItem alloc] init];
               [tempDocumentItem setEdition:self.currentDocument.documentID];
               [tempDocumentItem setHref:[[item attributeForName:@"href"] stringValue]];
               [tempDocumentItem setItemID:[[item attributeForName:@"id"] stringValue]];
               
               NSArray *label = [item elementsForName:@"label"];
               if ([label count] == 1) {
                   [tempDocumentItem setLabel:[[label objectAtIndex:0] stringValue]];
               }
               
               NSArray *department = [item elementsForName:@"department"];
               if ([department count] == 1) {
                   [tempDocumentItem setUri:[[[department objectAtIndex:0] attributeForName:@"id"] stringValue]];
                   /*[tempDocumentItem setLocation:[locationConnector loadLocationForUri:[[[department objectAtIndex:0] attributeForName:@"id"] stringValue]]];
                   if (![tempDocumentItem.location.shortname isEqualToString:@""]) {
                       [tempDocumentItem setDepartment:tempDocumentItem.location.shortname];
                   } else {
                       [tempDocumentItem setDepartment:tempDocumentItem.location.name];
                   }*/
               }
               
               NSArray *storage = [item elementsForName:@"storage"];
               if ([storage count] == 1) {
                   [tempDocumentItem setStorage:[[storage objectAtIndex:0] stringValue]];
               }
               
               tempDocumentItem.services = [[NSMutableArray alloc] init];
               NSArray *availableItems = [item elementsForName:@"available"];
               for (GDataXMLElement *availableItem in availableItems) {
                   BADocumentItemElement *tempDocumentItemElement = [[BADocumentItemElement alloc] init];
                   [tempDocumentItemElement setAvailable:YES];
                   [tempDocumentItemElement setType:@"available"];
                   [tempDocumentItemElement setHref:[[availableItem attributeForName:@"href"] stringValue]];
                   if ([[[availableItem attributeForName:@"href"] stringValue] isEqualToString:@""] || [[availableItem attributeForName:@"href"] stringValue] == nil) {
                       [tempDocumentItemElement setOrder:NO];
                   } else {
                       [tempDocumentItemElement setOrder:YES];
                   }
                   [tempDocumentItemElement setService:[[availableItem attributeForName:@"service"] stringValue]];
                   [tempDocumentItemElement setDelay:[[availableItem attributeForName:@"delay"] stringValue]];
                   [tempDocumentItemElement setMessage:[[availableItem attributeForName:@"message"] stringValue]];
                   [tempDocumentItemElement setLimitation:[[availableItem attributeForName:@"limitation"] stringValue]];
                   [tempDocumentItemElement setExpected:[[availableItem attributeForName:@"expected"] stringValue]];
                   [tempDocumentItemElement setQueue:[[availableItem attributeForName:@"queue"] stringValue]];
                   [tempDocumentItem.services addObject:tempDocumentItemElement];
               }
               tempDocumentItem.unavailable = [[NSMutableArray alloc] init];
               NSArray *unavailableItems = [item elementsForName:@"unavailable"];
               for (GDataXMLElement *unavailableItem in unavailableItems) {
                   BADocumentItemElement *tempDocumentItemElement = [[BADocumentItemElement alloc] init];
                   [tempDocumentItemElement setAvailable:NO];
                   [tempDocumentItemElement setType:@"unavailable"];
                   [tempDocumentItemElement setHref:[[unavailableItem attributeForName:@"href"] stringValue]];
                   if ([[[unavailableItem attributeForName:@"href"] stringValue] isEqualToString:@""] || [[unavailableItem attributeForName:@"href"] stringValue] == nil) {
                       [tempDocumentItemElement setOrder:NO];
                   } else {
                       [tempDocumentItemElement setOrder:YES];
                   }
                   [tempDocumentItemElement setService:[[unavailableItem attributeForName:@"service"] stringValue]];
                   [tempDocumentItemElement setDelay:[[unavailableItem attributeForName:@"delay"] stringValue]];
                   [tempDocumentItemElement setMessage:[[unavailableItem attributeForName:@"message"] stringValue]];
                   [tempDocumentItemElement setLimitation:[[unavailableItem attributeForName:@"limitation"] stringValue]];
                   [tempDocumentItemElement setExpected:[[unavailableItem attributeForName:@"expected"] stringValue]];
                   [tempDocumentItemElement setQueue:[[unavailableItem attributeForName:@"queue"] stringValue]];
                   [tempDocumentItem.services addObject:tempDocumentItemElement];
               }
              
               if ([availableItems count] == 0 && [unavailableItems count] == 0) {
                  tempDocumentItem.daiaInfoFromOpac = YES;
               }
              
               [self.currentDocument.items addObject:tempDocumentItem];
           }
       } else {
          DAIAParser *daiaParser = [[DAIAParser alloc] init];
          [daiaParser parseDAIAForDocument:self.currentDocument WithResult:result];
       }
       
        NSMutableArray *tempItems = [[NSMutableArray alloc] init];
        for (BADocumentItem *item in self.currentDocument.items) {
            BADocumentItem *workingItem;
            BOOL foundItem = NO;
            
            if (item.uri == nil) {
                [item setUri:BALocalizedString(@"Zusätzliche Exemplare anderer Bibliotheken")];
            }
            
            for (BADocumentItem *tempWorkingItem in tempItems) {
                if (item.uri != nil && tempWorkingItem.uri != nil) {
                    if ([item.uri isEqualToString:tempWorkingItem.uri]) {
                        foundItem = YES;
                        workingItem = tempWorkingItem;
                    }
                }
            }
            if (!foundItem) {
                workingItem = [[BADocumentItem alloc] init];
                NSString *tempUri;
                if (item.uri != nil) {
                    tempUri = item.uri;
                } else {
                    tempUri = BALocalizedString(@"Zusätzliche Exemplare anderer Bibliotheken");
                }
                if ([tempUri isEqualToString:BALocalizedString(@"Zusätzliche Exemplare anderer Bibliotheken")]) {
                   [workingItem setDepartment:tempUri];
                } else {
                   [workingItem setDepartment:@"..."];
                }
                [workingItem setLabel:item.label];
                [workingItem setLocation:item.location];
                [workingItem setUri:tempUri];
                [tempItems addObject:workingItem];
            } else {
                NSMutableString *tempLabelString = [workingItem.label mutableCopy];
                [tempLabelString appendFormat:@", %@", item.label];
                [workingItem setLabel:tempLabelString];
            }
        }
        
        NSArray *sortedArray;
        
        CLLocation *myLocation = self.appDelegate.locationManager.location;
        
        if (myLocation == nil) {
            sortedArray = [tempItems sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSString *first = [(BADocumentItem*)a uri];
                NSString *second = [(BADocumentItem*)b uri];
                return [first compare:second];
            }];
        } else {
            sortedArray = [tempItems sortedArrayUsingComparator:^(id a,id b) {
                CLLocation *aLocation = [[CLLocation alloc] initWithLatitude:[[[(BADocumentItem*)a location] geoLat] floatValue] longitude:[[[(BADocumentItem*)a location] geoLong] floatValue]];
                CLLocation *bLocation = [[CLLocation alloc] initWithLatitude:[[[(BADocumentItem*)b location] geoLat] floatValue] longitude:[[[(BADocumentItem*)b location] geoLong] floatValue]];
                
                CLLocationDistance distanceA = [aLocation distanceFromLocation:myLocation];
                CLLocationDistance distanceB = [bLocation distanceFromLocation:myLocation];
                
                if (distanceA < distanceB) {
                    return NSOrderedAscending;
                } else if (distanceA > distanceB) {
                    return NSOrderedDescending;
                } else {
                    return NSOrderedSame;
                }
            }];
            for (BADocumentItem *distanceItem in sortedArray) {
                if (![distanceItem.location.geoLong isEqualToString:@""] && ![distanceItem.location.geoLat isEqualToString:@""] && distanceItem.location.geoLong != nil && distanceItem.location.geoLat != nil) {
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:[[[distanceItem location] geoLat] floatValue] longitude:[[[distanceItem location] geoLong] floatValue]];
                    CLLocationDistance distance = [location distanceFromLocation:myLocation];
                    NSString *department = [[NSString alloc] initWithFormat:@"%@ (%.f km)", [distanceItem department] , (round(distance) / 1000)];
                    [distanceItem setDepartment:department];
                }
            }
        }
        
        [self.currentDocument setItems:[sortedArray mutableCopy]];
        
        [self.detailTableView reloadData];
        self.detailTableView.tableFooterView = nil;
    } else if ([command isEqualToString:@"getUNAPIDetailsIsbd"]) {
        NSString *resultString = [[NSString alloc] initWithData:(NSData *)result encoding:NSASCIIStringEncoding];
        
        const char *c = [resultString cStringUsingEncoding:NSISOLatin1StringEncoding];
        NSString *newString = [[NSString alloc]initWithCString:c encoding:NSUTF8StringEncoding];
        NSMutableArray *newStringArray = [[newString componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
        
        NSMutableString *displayString = [[NSMutableString alloc] initWithFormat:@""];
        
        int currentLine = 0;
        
        if ([newStringArray count] > currentLine) {
            NSRegularExpression *regexLine = [NSRegularExpression regularExpressionWithPattern:@"^\\[.*\\](?=\\n)" options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *resultsLine = [regexLine matchesInString:[newStringArray objectAtIndex:currentLine] options:0 range:NSMakeRange(0, [[newStringArray objectAtIndex:currentLine] length])];
            if ([resultsLine count] > 0) {
                currentLine++;
            }
        }
        
        if ([newStringArray count] > currentLine) {
            if ([[newStringArray objectAtIndex:currentLine] hasSuffix:@":"]) {
                currentLine++;
            }
        }
        
        if ([newStringArray count] > currentLine) {
            NSRegularExpression *regexLine = [NSRegularExpression regularExpressionWithPattern:@"^\\[.*\\]" options:NSRegularExpressionCaseInsensitive error:nil];
            NSArray *resultsLine = [regexLine matchesInString:[newStringArray objectAtIndex:currentLine] options:0 range:NSMakeRange(0, [[newStringArray objectAtIndex:currentLine] length])];
            if ([resultsLine count] > 0) {
                NSArray *resultPartsBracket = [[newStringArray objectAtIndex:currentLine] componentsSeparatedByString:@"]"];
                if ([resultPartsBracket count] > 0) {
                    NSMutableString *tempBracketString = [[NSMutableString alloc] init];
                    BOOL firstPart = YES;
                    for (int i = 1; i < [resultPartsBracket count]; i++) {
                       if (!firstPart) {
                          [tempBracketString appendString:@"]"];
                       } else {
                          firstPart = NO;
                       }
                       [tempBracketString appendString:[resultPartsBracket objectAtIndex:i]];
                    }
                    [newStringArray setObject:tempBracketString atIndexedSubscript:currentLine];
                } else {
                    [newStringArray setObject:@"" atIndexedSubscript:currentLine];
                }
            }
            NSArray *resultPartsSlash = [[newStringArray objectAtIndex:currentLine] componentsSeparatedByString:@" / "];
            if ([resultPartsSlash count] > 1) {
                BOOL firstPart = YES;
                for (int i = 1; i < [resultPartsSlash count]; i++) {
                   if (!firstPart) {
                      [displayString appendString:@" / "];
                   } else {
                      firstPart = NO;
                   }
                   [displayString appendString:[resultPartsSlash objectAtIndex:i]];
                }
            } else {
                NSArray *resultPartsDash = [[newStringArray objectAtIndex:currentLine] componentsSeparatedByString:@" - "];
                if ([resultPartsDash count] > 1) {
                    [displayString appendString:[resultPartsDash objectAtIndex:1]];
                } else {
                    [displayString appendString:[newStringArray objectAtIndex:currentLine]];
                }
            }
        }
        
        currentLine++;
        
        if ([newStringArray count] > currentLine) {
            NSArray *resultPartsCongress = [[newStringArray objectAtIndex:currentLine] componentsSeparatedByString:@"Congress: "];
            if ([resultPartsCongress count] > 1) {
                [displayString appendString:[resultPartsCongress objectAtIndex:1]];
            } else {
                if ((self.currentEntry.partName != nil) && (self.currentEntry.partNumber != nil)) {
                    NSArray *resultPartsDash = [[newStringArray objectAtIndex:currentLine] componentsSeparatedByString:@" - "];
                    if ([resultPartsDash count] > 1) {
                        [displayString appendString:[resultPartsDash objectAtIndex:1]];
                    }
                }
            }
        }
       
        for (int i = currentLine; i < [newStringArray count]-1; i++) {
           NSString *tempString = [newStringArray objectAtIndex:i];
           if ([tempString hasPrefix:@"In: "]) {
              if (![displayString isEqualToString:@""]) {
                 [displayString appendString:@"\n"];
              }
              [displayString appendString:tempString];
           }
        }

        [self.isbdLabel setText:displayString];
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            [self.currentEntryLocal setInfoText:displayString];
        } else {
            [self.currentEntry setInfoText:displayString];
        }
    } else if ([command isEqualToString:@"getUNAPIDetailsMods"]) {
        GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
        NSArray *modsArray = [parser nodesForXPath:@"_def_ns:mods" error:nil];
        if ([modsArray count] > 0) {
            GDataXMLElement *mods = [modsArray objectAtIndex:0];
            GDataXMLElement *relatedItemToc = (GDataXMLElement *)[[mods elementsForName:@"relatedItem"] objectAtIndex:0];
            [self.currentEntry setTocArray:[[NSMutableArray alloc] init]];
            [self.currentEntryLocal setTocArray:[[NSMutableArray alloc] init]];
            if (relatedItemToc != nil) {
                NSArray *locationsToc = [relatedItemToc elementsForName:@"location"];
                if (locationsToc != nil) {
                    for (GDataXMLElement *locationToc in locationsToc) {
                        GDataXMLElement *urlToc = (GDataXMLElement *)[[locationToc elementsForName:@"url"] objectAtIndex:0];
                        if (urlToc != nil) {
                            [self.currentEntry.tocArray addObject:[urlToc stringValue]];
                            [self.currentEntryLocal.tocArray addObject:[urlToc stringValue]];
                        }
                    }
                }
            }
           
            [self.currentEntry setOnlineLocation:nil];
            [self.currentEntryLocal setOnlineLocation:nil];
            NSArray *onlineLocations = [mods elementsForName:@"location"];
            for (GDataXMLElement *onlineLocation in onlineLocations) {
               if (onlineLocation != nil) {
                  GDataXMLElement *onlineLocationUrl = (GDataXMLElement *)[[onlineLocation elementsForName:@"url"] objectAtIndex:0];
                  if (onlineLocationUrl != nil) {
                     NSRange rangeValueType = [[[onlineLocationUrl attributeForName:@"usage"] stringValue] rangeOfString:@"primary display" options:NSCaseInsensitiveSearch];
                     if (rangeValueType.length > 0) {
                        [self.currentEntry setOnlineLocation:[onlineLocationUrl stringValue]];
                        [self.currentEntryLocal setOnlineLocation:[onlineLocationUrl stringValue]];
                     }
                  }
               }
            }
           
            [self.currentEntry setIsbn:@""];
            [self.currentEntryLocal setIsbn:@""];
            GDataXMLElement *tempISBNElement = (GDataXMLElement *)[[mods elementsForName:@"identifier"] objectAtIndex:0];
            if (tempISBNElement != nil) {
                NSRange rangeValue = [[[tempISBNElement attributeForName:@"type"] stringValue] rangeOfString:@"isbn" options:NSCaseInsensitiveSearch];
                if (rangeValue.length > 0) {
                    NSRegularExpression *regexLine = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+)" options:NSRegularExpressionCaseInsensitive error:nil];
                    NSArray *resultsISBN = [regexLine matchesInString:[tempISBNElement stringValue] options:0 range:NSMakeRange(0, [[tempISBNElement stringValue] length])];
                    if ([resultsISBN count] > 0) {
                        for (NSTextCheckingResult *match in resultsISBN) {
                            NSRange matchRange = [match rangeAtIndex:1];
                            [self.currentEntry setIsbn:[[tempISBNElement stringValue] substringWithRange:matchRange]];
                            [self.currentEntryLocal setIsbn:[[tempISBNElement stringValue] substringWithRange:matchRange]];
                        }
                    }
                }
            }
        }
        if([self.currentEntry.tocArray count] > 0){
            [self.tocButton setHidden:NO];
            [self.tocTitleButton setHidden:NO];
            [self.tocTableViewController.tocArray removeAllObjects];
            [self.tocTableViewController.tocArray addObjectsFromArray:self.currentEntry.tocArray];
        }
        [self.detailTableView reloadData];
    } else if ([command isEqualToString:@"getUNAPIDetailsPicaxml"]) {
        NSEnumerator *picaXmlEnumerator = [self.appDelegate.configuration.currentBibBlockOrderTypes keyEnumerator];
        GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
        NSArray *picaDatafieldsArray = [parser.rootElement elementsForName:@"datafield"];
        for (id key in picaXmlEnumerator) {
            for (GDataXMLElement *picaDatafield in picaDatafieldsArray) {
                if ([[[picaDatafield attributeForName:@"tag"] stringValue] isEqualToString:key]) {
                    NSArray *picaSubfieldsArray = [picaDatafield elementsForName:@"subfield"];
                    for (GDataXMLElement *picaSubfield in picaSubfieldsArray) {
                        NSEnumerator *blockOrderTypesEnumerator = [[self.appDelegate.configuration.currentBibBlockOrderTypes objectForKey:key] keyEnumerator];
                        for (id blockOrderTypeKey in blockOrderTypesEnumerator) {
                            if ([[[picaSubfield stringValue] substringWithRange:NSMakeRange([[[self.appDelegate.configuration.currentBibBlockOrderTypes objectForKey:key] objectForKey:blockOrderTypeKey] longValue], 1)] isEqualToString:blockOrderTypeKey]) {
                                self.blockOrderByTypes = YES;
                            }
                        }
                    }
                }
            }
        }
        BAConnector *connector = [BAConnector generateConnector];
        if (!self.blockOrderByTypes) {
            [connector getDetailsForLocal:[self.currentEntryLocal ppn] WithDelegate:self];
        } else {
            if (self.appDelegate.configuration.useDAIASubRequests) {
                [connector getDetailsForLocalFam:[self.currentEntryLocal ppn] WithStart:self.currentDaiaFamIndex WithDelegate:self];
            }
        }
    } else if ([command isEqualToString:@"accountRequestDocs"]) {
       if ([self.appDelegate.configuration usePAIAWrapper]) {
          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
          if ([json count] > 0) {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:BALocalizedString(@"Bestellung / Vormerkung\nerfolgreich")
                                                            delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
             [alert show];
          } else {
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                             message:BALocalizedString(@"Bestellung / Vormerkung\nleider nicht möglich")
                                                            delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
             [alert show];
          }
       } else {
          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
          if ([json objectForKey:@"error"] == nil && [json objectForKey:@"doc"] != nil) {
             NSDictionary *doc = [[json objectForKey:@"doc"] objectAtIndex:0];
             if ([doc objectForKey:@"error"] == nil) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:BALocalizedString(@"Bestellung / Vormerkung\nerfolgreich") delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
                [alert show];
             } else {
                NSString *errorString = [[NSString alloc] initWithFormat:BALocalizedString(@"Bestellung / Vormerkung\nleider nicht möglich:\n%@"), [doc objectForKey:@"error"]];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:errorString delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
                [alert show];
             }
          } else {
             NSString *errorString = [[NSString alloc] initWithFormat:BALocalizedString(@"Bestellung / Vormerkung\nleider nicht möglich:\n%@"), [json objectForKey:@"error_description"]];
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:errorString delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
             [alert show];
          }
       }
    } else if ([command isEqualToString:@"getDetailsLocalFam"]) {
        GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
        
        NSArray *items = [parser nodesForXPath:@"RESULT/SET/SHORTTITLE" error:nil];
        if ([items count] > 0) {
            for (GDataXMLElement *item in items) {
                NSString *ppn = [[item attributeForName:@"PPN"] stringValue];
                
                NSLog(@"PPN: %@", ppn);
                
                if (![ppn isEqualToString:self.currentEntryLocal.ppn]) {
                    BAConnector *connector = [BAConnector generateConnector];
                    [connector getDetailsForLocal:ppn WithDelegate:self];
                }
            }
        } else {
            BAConnector *connector = [BAConnector generateConnector];
            [connector getDetailsForLocal:[self.currentEntryLocal ppn] WithDelegate:self];
        }
        
        NSArray *sets = [parser nodesForXPath:@"RESULT/SET" error:nil];
        for (GDataXMLElement *set in sets) {
            if ([[[set attributeForName:@"hits"] stringValue] longLongValue] > (self.currentDaiaFamIndex + 10) ) {
                self.currentDaiaFamIndex += 10;
                BAConnector *famConnector = [BAConnector generateConnector];
                [famConnector getDetailsForLocalFam:[self.currentEntryLocal ppn] WithStart:self.currentDaiaFamIndex WithDelegate:self];
            }
        }
    }
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}


- (void)segmentAction:(id)sender
{
    [self.searchTableView reloadData];
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        [self.searchBar setText:self.lastSearchLocal];
        if (self.searchedLocal) {
            [self.navigationBarSearch.topItem setTitle:[[NSString alloc] initWithFormat:BALocalizedString(@"Lokale Suche (%ld Treffer)"), (long)self.searchCountLocal]];
        } else {
            //[self.navigationBarSearch.topItem setTitle:@"Lokale Suche"];
            [self.navigationBarSearch.topItem setTitle:[self.appDelegate.configuration getSearchTitleForCatalog:self.appDelegate.options.selectedCatalogue]];
        }
        if (self.booksLocal != nil) {
            [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.positionLocal inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    } else {
        [self.searchBar setText:self.lastSearch];
        if (self.searched) {
            [self.navigationBarSearch.topItem setTitle:[[NSString alloc] initWithFormat:BALocalizedString(@"GVK Suche (%ld Treffer)"), (long)self.searchCount]];
        } else {
            [self.navigationBarSearch.topItem setTitle:BALocalizedString(@"GVK Suche")];
        }
        if (self.booksGVK != nil) {
            [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.position inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
    [self showDetailView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
       if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
          if ([self.booksLocal count] > 0) {
             return 73.0;
          } else if (self.searchedLocal) {
             return 600.0;
          } else {
             return 73.0;
          }
       } else {
          if ([self.booksGVK count] > 0) {
             return 73.0;
          } else if (self.searched) {
             return 600.0;
          } else {
             return 73.0;
          }
       }
    } else {
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            return 87;
        } else {
            return 43;
        }
    }
}

- (void)initDetailView{
    [self.coverView setHidden:YES];
    [self.titleLabel setHidden:YES];
    [self.subtitleLabel setHidden:YES];
    [self.isbdLabel setHidden:YES];
    [self.tocButton setHidden:YES];
    [self.tocTitleButton setHidden:YES];
    [self.loanButton setHidden:YES];
    [self.loanTitleButton setHidden:YES];
    [self.listButton setHidden:YES];
    [self.detailTableView setHidden:YES];
    
    [self.defaultTextView setHidden:NO];
    [self.defaultImageView setHidden:NO];
    
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        [self.defaultTextView setText:BALocalizedString(@"Suche im lokalen Katalog\nBitte geben Sie links einen Suchbegriff ein.")];
    } else {
        [self.defaultTextView setText:BALocalizedString(@"Suche im Gesamtkatalog\nBitte geben Sie links einen Suchbegriff ein.")];
    }
}

- (void)showDetailView{
    [self.defaultTextView setHidden:YES];
    [self.defaultImageView setHidden:YES];
    
    BAEntryWork *tempEntry;
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.positionLocal inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        tempEntry = self.currentEntryLocal;
    } else {
        [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.position inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        tempEntry = self.currentEntry;
    }
    
    if (tempEntry != nil) {
        [self.coverView setHidden:NO];
        [self.titleLabel setHidden:NO];
        [self.subtitleLabel setHidden:NO];
        [self.isbdLabel setHidden:NO];
        [self.listButton setHidden:NO];
        [self.detailTableView setHidden:NO];
        
        NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BAEntry" inManagedObjectContext:[self.appDelegate managedObjectContext]];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDescription];
        
        NSError *error = nil;
        NSArray *tempEntries = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
        BOOL foundPpn = NO;
        for (BAEntry *tempExistingEntry in tempEntries) {
            if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
                if ([self.currentEntryLocal.ppn isEqualToString:tempExistingEntry.ppn]) {
                    foundPpn = YES;
                }
            } else {
                if ([self.currentEntry.ppn isEqualToString:tempExistingEntry.ppn]) {
                    foundPpn = YES;
                }
            }
        }
        if (!foundPpn) {
            [self.listButton setTitle:BALocalizedString(@"Zur Merkliste hinzufügen") forState:UIControlStateNormal];
            [self.listButton setEnabled:YES];
        } else {
            [self.listButton setTitle:BALocalizedString(@"Bereits auf der Merkliste") forState:UIControlStateNormal];
            [self.listButton setEnabled:NO];
        }
        
        [self.tocButton addTarget:self action:@selector(tocAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tocTitleButton addTarget:self action:@selector(tocAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tocButton setHidden:YES];
        [self.tocTitleButton setHidden:YES];
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            if ([self.currentEntryLocal.tocArray count] > 0) {
                [self.tocButton setHidden:NO];
                [self.tocTitleButton setHidden:NO];
                
                [self.tocTableViewController.tocArray removeAllObjects];
                [self.tocTableViewController.tocArray addObjectsFromArray:tempEntry.tocArray];
            }
        } else {
            if (self.currentEntry.toc != nil) {
                [self.tocButton setHidden:NO];
                [self.tocTitleButton setHidden:NO];
            }
        }
        
        [self.loanButton addTarget:self action:@selector(loanAction) forControlEvents:UIControlEventTouchUpInside];
        [self.loanTitleButton addTarget:self action:@selector(loanAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.loanButton setHidden:YES];
        [self.loanTitleButton setHidden:YES];
        if ([self.searchSegmentedController selectedSegmentIndex] == 1) {
            [self.loanButton setHidden:NO];
            [self.loanTitleButton setHidden:NO];
        }
        
        [self.titleLabel setText:tempEntry.title];
        [self.subtitleLabel setText:tempEntry.subtitle];
        
        self.computedSizeOfTitleCell = 0;
        self.didLoadISBD = NO;
        
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            [self.isbdLabel setText:self.currentEntryLocal.infoText];
        } else {
            [self.isbdLabel setText:self.currentEntry.infoText];
        }
        
        BADocument *document = [[BADocument alloc] init];
        [self setCurrentDocument:document];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, 320, 44);
        self.detailTableView.tableFooterView = spinner;
        
        BAConnector *connector = [BAConnector generateConnector];
        BAConnector *unapiConnector = [BAConnector generateConnector];
        BAConnector *unapiConnectorMods = [BAConnector generateConnector];
        
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            if ([self.appDelegate.configuration.currentBibBlockOrderTypes count] == 0) {
                [connector getDetailsForLocal:[self.currentEntryLocal ppn] WithDelegate:self];
            } else {
                BAConnector *unapiConnectorPica = [BAConnector generateConnector];
                [unapiConnectorPica getUNAPIDetailsFor:[self.currentEntryLocal ppn] WithFormat:@"picaxml" WithDelegate:self];
            }
            
            [unapiConnector getUNAPIDetailsFor:[self.currentEntryLocal ppn] WithFormat:@"isbd" WithDelegate:self];
            [unapiConnectorMods getUNAPIDetailsFor:[self.currentEntryLocal ppn] WithFormat:@"mods" WithDelegate:self];
        } else {
            [connector getDetailsFor:[self.currentEntry ppn] WithDelegate:self];
            [unapiConnector getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"isbd" WithDelegate:self];
            [unapiConnectorMods getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"mods" WithDelegate:self];
        }
       
        if ([self.currentEntry isKindOfClass:[BAEntryWork class]]) {
           [self setCover:[self.currentEntry mediaIcon]];
        } else {
           [self setCover:[UIImage imageNamed:self.currentEntry.matcode]];
        }
       
        [self.coverView setContentMode:UIViewContentModeCenter];
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
           [self.coverView setImage:self.currentEntryLocal.mediaIcon];
        } else {
           [self.coverView setImage:self.currentEntry.mediaIcon];
        }
       
        [self.coverActivityIndicator startAnimating];
        [self performSelectorInBackground:@selector(loadCover) withObject:nil];
    } else {
        [self initDetailView];
    }
}

- (void)loadCover{
    NSString *urlStringISBN;
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        urlStringISBN = [[NSString alloc] initWithFormat:@"http://ws.gbv.de/covers/?id=%@&format=img", [self.currentEntryLocal isbn]];
    } else {
        urlStringISBN = [[NSString alloc] initWithFormat:@"http://ws.gbv.de/covers/?id=%@&format=img", [self.currentEntry isbn]];
    }
    NSURL *url = [NSURL URLWithString: [[NSString alloc] initWithString:urlStringISBN]];
    UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
    if (image.size.height > 1 && image.size.width > 1) {
        [self.coverView setContentMode:UIViewContentModeScaleAspectFit];
        [self.coverView setImage:image];
        [self.coverView setUserInteractionEnabled:YES];
        [self setCover:image];
        self.foundCover = YES;
    } else {
        NSString *urlStringPPN;
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            urlStringPPN = [[NSString alloc] initWithFormat:@"http://ws.gbv.de/covers/?id=%@&format=img", [self.currentEntryLocal ppn]];
        } else {
            urlStringPPN = [[NSString alloc] initWithFormat:@"http://ws.gbv.de/covers/?id=%@&format=img", [self.currentEntry ppn]];
        }
        NSURL *url = [NSURL URLWithString: [[NSString alloc] initWithString:urlStringPPN]];
        UIImage *image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        if (image.size.height > 1 && image.size.width > 1) {
            [self.coverView setContentMode:UIViewContentModeScaleAspectFit];
            [self.coverView setImage:image];
            [self.coverView setUserInteractionEnabled:YES];
            [self setCover:image];
            self.foundCover = YES;
        } else {
            [self.coverView setUserInteractionEnabled:NO];
            [self setCover:nil];
            self.foundCover = NO;
        }
    }
    [self.coverActivityIndicator stopAnimating];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            self.currentEntryLocal = [self.booksLocal objectAtIndex:[indexPath row]];
            [self setPositionLocal:[indexPath row]];
        } else {
            self.currentEntry = [self.booksGVK objectAtIndex:[indexPath row]];
            [self setPosition:[indexPath row]];
        }
        [self showDetailView];
    } else if (tableView.tag == 1) {
        [self actionButtonClick:[tableView cellForRowAtIndexPath:indexPath]];
    }
}

- (void)activateActionButton:(UIButton *) button
{
    BOOL hideActionButton = YES;
    
    BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:button.tag];
    BADocumentItemElement *presentation;
    BADocumentItemElement *loan;
    
    [self setCurrentLocation:tempDocumentItem.location];
    
    for (BADocumentItemElement *element in tempDocumentItem.services) {
        if ([element.service isEqualToString:@"presentation"]) {
            presentation = element;
        } else if ([element.service isEqualToString:@"loan"]) {
            loan = element;
        }
    }
    
    BAEntryWork *tempEntry;
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        tempEntry = self.currentEntryLocal;
    } else {
        tempEntry = self.currentEntry;
    }
    
    BOOL tempShowButton = NO;
    if (tempEntry.onlineLocation == nil) {
        if (loan.available) {
            if (presentation.available) {
                if (loan.href != nil) {
                    tempShowButton = YES;
                }
            }
        } else {
            if (!presentation.available) {
                if (loan.href != nil) {
                    tempShowButton = YES;
                }
            }
        }
        if (tempShowButton || (tempDocumentItem.location != nil)) {
            hideActionButton = NO;
        }
    } else {
        hideActionButton = NO;
    }
    
    [button setHidden:hideActionButton];
}

- (void)actionButtonClick:(id)sender {
    //UIButton *clicked = (UIButton *) sender;
    UITableViewCell *clicked = (UITableViewCell *) sender;
    
    BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:clicked.tag];
    BADocumentItemElement *presentation;
    BADocumentItemElement *loan;
    
    [self setCurrentLocation:tempDocumentItem.location];
    
    for (BADocumentItemElement *element in tempDocumentItem.services) {
        if ([element.service isEqualToString:@"presentation"]) {
            presentation = element;
        } else if ([element.service isEqualToString:@"loan"]) {
            loan = element;
        }
    }
    
    BAEntryWork *tempEntry;
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        tempEntry = self.currentEntryLocal;
    } else {
        tempEntry = self.currentEntry;
    }
    
    NSMutableString *orderString = [[NSMutableString alloc] init];
    if (tempEntry.onlineLocation == nil) {
        if (loan.available) {
            if (presentation.available) {
                if (loan.href != nil) {
                    [orderString appendString:BALocalizedString(@"Bestellen")];
                }
            }
        } else {
            if (!presentation.available) {
                if (loan.href != nil) {
                    [orderString appendString:self.appDelegate.configuration.currentBibRequestTitle];
                }
            } else {
                NSRange match = [presentation.href rangeOfString: @"action=order"];
                if (match.length > 0) {
                    [orderString appendString:BALocalizedString(@"Bestellen")];
                }
            }
        }
        UIActionSheet *action;
        if (tempDocumentItem.order) {
            if (tempDocumentItem.location != nil) {
                action = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:BALocalizedString(@"Abbrechen")
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:orderString, BALocalizedString(@"Standortinfo"), BALocalizedString(@"Abbrechen"), nil];
            } else {
                action = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:BALocalizedString(@"Abbrechen")
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:orderString, BALocalizedString(@"Abbrechen"), nil];
            }
        } else {
            action = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:BALocalizedString(@"Abbrechen")
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:BALocalizedString(@"Standortinfo"), BALocalizedString(@"Abbrechen"), nil];
        }
        [action setTag:clicked.tag];
        if (![orderString isEqualToString:@""] || (tempDocumentItem.location != nil)) {
            CGRect cellRect = [self.detailTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:clicked.tag inSection:0]];
            if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
                //[action showFromRect:CGRectMake(cellRect.origin.x+625, cellRect.origin.y-7, 200, 100) inView:self.detailTableView animated:YES];
                [action showFromRect:CGRectMake(cellRect.origin.x, cellRect.origin.y, 200, 100) inView:self.detailTableView animated:YES];
            } else {
                //[action showFromRect:CGRectMake(cellRect.origin.x+625, cellRect.origin.y-28, 200, 100) inView:self.detailTableView animated:YES];
                [action showFromRect:CGRectMake(cellRect.origin.x, cellRect.origin.y, 200, 100) inView:self.detailTableView animated:YES];
            }
        }
    } else {
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:BALocalizedString(@"Abbrechen")
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:BALocalizedString(@"Im Browser öffnen"), BALocalizedString(@"Abbrechen"), nil];
        [action setTag:clicked.tag];
        CGRect cellRect = [self.detailTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:clicked.tag inSection:0]];
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            //[action showFromRect:CGRectMake(cellRect.origin.x+625, cellRect.origin.y-7, 200, 100) inView:self.detailTableView animated:YES];
            [action showFromRect:CGRectMake(cellRect.origin.x, cellRect.origin.y, 200, 100) inView:self.detailTableView animated:YES];
        } else {
            //[action showFromRect:CGRectMake(cellRect.origin.x+625, cellRect.origin.y-28, 200, 100) inView:self.detailTableView animated:YES];
            [action showFromRect:CGRectMake(cellRect.origin.x, cellRect.origin.y, 200, 100) inView:self.detailTableView animated:YES];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    BAEntryWork *tempEntry;
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        tempEntry = self.currentEntryLocal;
    } else {
        tempEntry = self.currentEntry;
    }

    NSInteger itemIndex = actionSheet.tag;
    if (buttonIndex == 0) {
        if ([[actionSheet buttonTitleAtIndex:0] isEqualToString:BALocalizedString(@"Bestellen")] || [[actionSheet buttonTitleAtIndex:0] isEqualToString:self.appDelegate.configuration.currentBibRequestTitle]) {
            if (self.appDelegate.currentAccount != nil && self.appDelegate.currentToken != nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                [tempArray addObject:[self.currentDocument.items objectAtIndex:itemIndex]];
                BAConnector *requestConnector = [BAConnector generateConnector];
                [requestConnector accountRequestDocs:tempArray WithAccount:self.appDelegate.currentAccount WithToken:self.appDelegate.currentToken WithDelegate:self];
            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:BALocalizedString(@"Sie müssen sich zuerst anmelden. Wechseln Sie dazu bitte in den Bereich Konto")
                                                               delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
                [alert show];
            }
        } else if ([[actionSheet buttonTitleAtIndex:0] isEqualToString:BALocalizedString(@"Standortinfo")]) {
            //[self showLocation];
            [self performSelector: @selector(showLocation) withObject: nil afterDelay: 0];
        } else if ([[actionSheet buttonTitleAtIndex:0] isEqualToString:BALocalizedString(@"Im Browser öffnen")]) {
            NSURL *url = [NSURL URLWithString:tempEntry.onlineLocation];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    } else if (buttonIndex == 1) {
        if ([[actionSheet buttonTitleAtIndex:1] isEqualToString:BALocalizedString(@"Standortinfo")]) {
            //[self showLocation];
            [self performSelector: @selector(showLocation) withObject: nil afterDelay: 0];
        }
    }
}

- (void)showLocation{
    [self performSegueWithIdentifier:@"locationSegue" sender:self];
}

- (void)displayToc {
    [self.tocPopoverController dismissPopoverAnimated:NO];
    [self performSelector: @selector(showToc) withObject: nil afterDelay: 0];
}

- (void)showToc{
    [self performSegueWithIdentifier:@"tocSegue" sender:self];
}

- (void)coverTap {
    [self performSegueWithIdentifier:@"coverSegue" sender:self];
}

- (void)tocAction:(id)sender{
    [self setTocPopoverController: [[UIPopoverController alloc] initWithContentViewController:self.tocTableViewController]];
    [self.tocPopoverController setDelegate:self];
    UIButton* senderButton = (UIButton*)sender;
    [self.tocPopoverController setPopoverContentSize:CGSizeMake(450, 200)];
    [self.tocPopoverController presentPopoverFromRect:senderButton.bounds inView:senderButton permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
}

- (void)loanAction
{
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://gso.gbv.de/DB=2.1/PPNSET?PPN=%@", self.currentEntry.ppn]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"coverSegue"]) {
        BACoverViewControllerPad *coverViewController = (BACoverViewControllerPad *)[segue destinationViewController];
        [coverViewController setCoverImage:self.cover];
    } else if ([[segue identifier] isEqualToString:@"locationSegue"]) {
        BALocationViewControllerPad *locationViewController = (BALocationViewControllerPad *)[segue destinationViewController];
        [locationViewController setCurrentLocation:self.currentLocation];
    } else if ([[segue identifier] isEqualToString:@"tocSegue"]) {
        BATocViewControllerPad *tocViewController = (BATocViewControllerPad *)[segue destinationViewController];
        [tocViewController setUrl:[self.tocTableViewController currentToc]];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchDisplayController:(UISearchController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    [tableView setFrame:CGRectMake(0, 117, 320, 582)];
    [tableView setHidden:YES];
}

- (IBAction)listAction:(id)sender {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BAEntry" inManagedObjectContext:[self.appDelegate managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *tempEntries = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    BOOL foundPpn = NO;
    for (BAEntry *tempExistingEntry in tempEntries) {
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            if ([self.currentEntryLocal.ppn isEqualToString:tempExistingEntry.ppn]) {
                foundPpn = YES;
            }
        } else {
            if ([self.currentEntry.ppn isEqualToString:tempExistingEntry.ppn]) {
                foundPpn = YES;
            }
        }
    }
    
    if (!foundPpn) {
        BAEntry *newEntry = (BAEntry *)[NSEntityDescription insertNewObjectForEntityForName:@"BAEntry" inManagedObjectContext:[self.appDelegate managedObjectContext]];
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            [newEntry setTitle:self.currentEntryLocal.title];
            [newEntry setSubtitle:self.currentEntryLocal.subtitle];
            [newEntry setPpn:self.currentEntryLocal.ppn];
            [newEntry setMatstring:self.currentEntryLocal.matstring];
            [newEntry setMatcode:self.currentEntryLocal.matcode];
            [newEntry setLocal:self.currentEntryLocal.local];
            [newEntry setAuthor:self.currentEntryLocal.author];
            [newEntry setYear:self.currentEntryLocal.year];
        } else {
            [newEntry setTitle:self.currentEntry.title];
            [newEntry setSubtitle:self.currentEntry.subtitle];
            [newEntry setPpn:self.currentEntry.ppn];
            [newEntry setMatstring:self.currentEntry.matstring];
            [newEntry setMatcode:self.currentEntry.matcode];
            [newEntry setLocal:self.currentEntry.local];
            [newEntry setAuthor:self.currentEntry.author];
            [newEntry setYear:self.currentEntry.year];
        }
        
        NSError *error = nil;
        if (![[self.appDelegate managedObjectContext] save:&error]) {
            // Handle the error.
        }
        
        [self.listButton setTitle:BALocalizedString(@"Bereits auf der Merkliste") forState:UIControlStateNormal];
        [self.listButton setEnabled:NO];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:BALocalizedString(@"Der Eintrag wurde Ihrer Merkliste hinzugefügt")
                                                       delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                        message:BALocalizedString(@"Der Eintrag befindet sich bereits auf Ihrer Merkliste")
                                                       delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
        [alert show];
    }
}

- (void)changeCatalogue:(NSNotification *)notif
{
    [self.searchSegmentedController setTitle:[self.appDelegate.configuration getTitleForCatalog:self.appDelegate.options.selectedCatalogue] forSegmentAtIndex:0];
    [self.booksLocal removeAllObjects];
    [self setInitialSearchLocal:YES];
    [self setSearchedLocal:NO];
    self.lastSearchLocal = @"";
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        [self initDetailView];
        //[self.navigationBarSearch.topItem setTitle:@"Lokale Suche"];
        [self.navigationBarSearch.topItem setTitle:[self.appDelegate.configuration getSearchTitleForCatalog:self.appDelegate.options.selectedCatalogue]];
        [self.searchBar setText:@""];
        [self.searchTableView reloadData];
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)commandIsNotInScope:(NSString *)command {
   self.searchTableView.tableFooterView = nil;
   self.detailTableView.tableFooterView = nil;
}

- (void)networkIsNotReachable:(NSString *)command {
   [self commandIsNotInScope:command];
}

- (void)searchGBV {
   self.lastSearch = self.lastSearchLocal;
   self.searched = NO;
   [self.searchSegmentedController setSelectedSegmentIndex:1];
   [self segmentAction:nil];
   [self searchBarSearchButtonClicked];
}

@end
