//
//  BASearchTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BASearchViewController.h"
#import "BADetailViewController.h"
#import "BAItemCell.h"
#import "BAConnector.h"
#import "BADetailScrollViewController.h"
#import "GDataXMLNode.h"

@interface BASearchViewController ()

@end

@implementation BASearchViewController

@synthesize booksLocal;
@synthesize booksGVK;
@synthesize currentEntry;
@synthesize positionLocal;
@synthesize position;
@synthesize searchBar;
@synthesize searchTableView;
@synthesize searchSegmentedController;
@synthesize lastSearchLocal;
@synthesize lastSearch;
@synthesize searchedLocal;
@synthesize searched;
@synthesize isSearching;
@synthesize searchCountLocal;
@synthesize searchCount;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCatalogue:) name:@"changeCatalogue" object:nil];
    
    [self.navigationController.navigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    [self.searchBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    [self.searchSegmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.searchSegmentedController setTintColor:self.appDelegate.configuration.currentBibTintColor];
    [self.searchSegmentedController setTitle:[self.appDelegate.configuration getTitleForCatalog:self.appDelegate.options.selectedCatalogue] forSegmentAtIndex:0];
    
    [self.navigationController.tabBarItem setTitle:self.appDelegate.configuration.searchTitle];
    
    self.lastSearchLocal = @"";
    self.lastSearch = @"";
    
    self.positionLocal = 0;
    self.position = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        return [self.booksLocal count];
    } else {
        return [self.booksGVK count];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.searchTableView reloadData];
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        if (self.searchedLocal) {
            [self.navigationItem setTitle:[[NSString alloc] initWithFormat:@"Lokale Suche (%d Treffer)", self.searchCountLocal]];
        } else {
            //[self.navigationItem setTitle:@"Lokale Suche"];
            [self.navigationItem setTitle:[self.appDelegate.configuration getSearchTitleForCatalog:self.appDelegate.options.selectedCatalogue]];
        }
        if ([self.booksLocal count] > 0) {
            [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.positionLocal inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }
    } else {
        if (self.searched) {
            [self.navigationItem setTitle:[[NSString alloc] initWithFormat:@"GVK Suche (%d Treffer)", self.searchCount]];
        } else {
            [self.navigationItem setTitle:@"GVK Suche"];
        }
        if ([self.booksGVK count] > 0) {
            [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.position inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BAItemCell *cell = (BAItemCell *) [tableView dequeueReusableCellWithIdentifier:@"BAItemCell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
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
    } else {
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
	[cell.titleLabel setText:entry.title];
    [cell.subtitleLabel setText:entry.subtitle];
    [cell.image setImage:[entry mediaIcon]];
    [cell.authorLabel setText:entry.author];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        self.currentEntry = [self.booksLocal objectAtIndex:[indexPath row]];
        [self setPositionLocal:[indexPath row]];
    } else {
        self.currentEntry = [self.booksGVK objectAtIndex:[indexPath row]];
        [self setPosition:[indexPath row]];
    }
    [self performSegueWithIdentifier:@"ItemDetailSegue" sender:self];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.searchTableView.tableFooterView = spinner;
    [self.searchTableView setContentOffset:CGPointMake(0, 0) animated:NO];
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        self.lastSearchLocal = self.searchBar.text;
        self.searchCountLocal = 0;
        self.booksLocal = [[NSMutableArray alloc] init];
        BAConnector *connector = [BAConnector generateConnector];
        [connector searchLocalFor:self.searchBar.text WithFirst:1 WithDelegate:self];
    } else {
        self.lastSearch = self.searchBar.text;
        self.searchCount = 0;
        self.booksGVK = [[NSMutableArray alloc] init];
        BAConnector *connector = [BAConnector generateConnector];
        [connector searchCentralFor:self.searchBar.text WithFirst:1 WithDelegate:self];
    }
    [self.searchTableView reloadData];
    [self.searchBar resignFirstResponder];
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
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
    }
    
    /*if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        //if ([self isFirstResponder]) {
            [self.navigationItem setTitle:[[NSString alloc] initWithFormat:@"Lokale Suche (%d Treffer)", self.searchCountLocal]];
        //}
        self.searchedLocal = YES;
    } else {
        //if ([self isFirstResponder]) {
            [self.navigationItem setTitle:[[NSString alloc] initWithFormat:@"GVK Suche (%d Treffer)", self.searchCount]];
        //}
        self.searched = YES;
    }*/
    if ([command isEqualToString:@"searchLocal"]) {
        if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
            [self.navigationItem setTitle:[[NSString alloc] initWithFormat:@"Lokale Suche (%d Treffer)", self.searchCountLocal]];
        }
        self.searchedLocal = YES;
    } else if ([command isEqualToString:@"searchCentral"]) {
        if ([self.searchSegmentedController selectedSegmentIndex] == 1) {
            [self.navigationItem setTitle:[[NSString alloc] initWithFormat:@"GVK Suche (%d Treffer)", self.searchCount]];
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
        
        [tempArray addObject:tempEntry];
    }
    /*if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        [self.booksLocal addObjectsFromArray:tempArray];
    } else {
        [self.booksGVK addObjectsFromArray:tempArray];
    }*/
    if ([command isEqualToString:@"searchLocal"]) {
        [self.booksLocal addObjectsFromArray:tempArray];
    } else if ([command isEqualToString:@"searchCentral"]) {
        [self.booksGVK addObjectsFromArray:tempArray];
    }
    
    [self.searchTableView reloadData];
    self.searchTableView.tableFooterView = nil;
    
    self.isSearching = NO;
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
            [self.navigationItem setTitle:[[NSString alloc] initWithFormat:@"Lokale Suche (%d Treffer)", self.searchCountLocal]];
        } else {
            //[self.navigationItem setTitle:@"Lokale Suche"];
            [self.navigationItem setTitle:[self.appDelegate.configuration getSearchTitleForCatalog:self.appDelegate.options.selectedCatalogue]];
        }
        if ([self.booksLocal count] > 0) {
            [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.positionLocal inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }
    } else {
        [self.searchBar setText:self.lastSearch];
        if (self.searched) {
            [self.navigationItem setTitle:[[NSString alloc] initWithFormat:@"GVK Suche (%d Treffer)", self.searchCount]];
        } else {
            [self.navigationItem setTitle:@"GVK Suche"];
        }
        if ([self.booksGVK count] > 0) {
            [self.searchTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.position inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ItemDetailSegue"]) {
        BADetailScrollViewController *detailScrollViewController = (BADetailScrollViewController *)[segue destinationViewController];
        [detailScrollViewController setScrollViewDelegate:self];
        [self.navigationItem setTitle:@"Suche"];
        if (self.currentEntry.local) {
            [detailScrollViewController setBookList:self.booksLocal];
            [detailScrollViewController setMaximumPosition:self.searchCountLocal];
            [detailScrollViewController setStartPosition:self.positionLocal];
        } else {
            [detailScrollViewController setBookList:self.booksGVK];
            [detailScrollViewController setMaximumPosition:self.searchCount];
            [detailScrollViewController setStartPosition:self.position];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63.0;
}

- (void)continueSearch
{
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        [self continueSearchFor:@"local"];
    } else {
        [self continueSearchFor:@"nonLocal"];
    }
}

- (void)updatePosition:(int)updatePosition
{
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        [self setPositionLocal:updatePosition];
    } else {
        [self setPosition:updatePosition];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)continueSearchFor:(NSString *)catalog
{
    if (!self.isSearching) {
        self.isSearching = YES;
        if ([catalog isEqualToString:@"local"]) {
            BAConnector *connector = [BAConnector generateConnector];
            [connector searchLocalFor:self.searchBar.text WithFirst:[self.booksLocal count]+1 WithDelegate:self];
        } else if ([catalog isEqualToString:@"nonLocal"]) {
            BAConnector *connector = [BAConnector generateConnector];
            [connector searchCentralFor:self.searchBar.text WithFirst:[self.booksGVK count]+1 WithDelegate:self];
        }
    }
}

- (void)changeCatalogue:(NSNotification *)notif
{
    [self.searchSegmentedController setTitle:[self.appDelegate.configuration getTitleForCatalog:self.appDelegate.options.selectedCatalogue] forSegmentAtIndex:0];
    [self.booksLocal removeAllObjects];
    [self setSearchedLocal:NO];
    self.lastSearchLocal = @"";
    if ([self.searchSegmentedController selectedSegmentIndex] == 0) {
        //[self.navigationItem setTitle:@"Lokale Suche"];
        [self.navigationItem setTitle:[self.appDelegate.configuration getSearchTitleForCatalog:self.appDelegate.options.selectedCatalogue]];
        [self.searchBar setText:@""];
        [self.searchTableView reloadData];
    }
}

- (void)commandIsNotInScope:(NSString *)command {
   self.searchTableView.tableFooterView = nil;
}

- (void)networkIsNotReachable:(NSString *)command {
   [self commandIsNotInScope:command];
}

@end
