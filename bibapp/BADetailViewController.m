//
//  BADetailViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAAppDelegate.h"
#import "BADetailViewController.h"
#import "BAItemDetail.h"
#import "BAItemDetailCell.h"
#import "BAConnector.h"
#import "BADocumentItem.h"
#import "BADocumentItemCell.h"
#import "BADocumentElement.h"
#import "BADocumentItemElement.h"
#import "BADocumentItemElementCell.h"
#import "BADocumentItemElementCellNonLocal.h"
#import "BAEntry.h"
#import "BAItemDetailTitleCell.h"
#import "BACoverViewControllerIPhone.h"
#import "BAPDFViewController.h"
#import "BATocViewController.h"
#import "BALocation.h"
#import "BALocationViewControllerIPhone.h"

#import "GDataXMLNode.h"

@interface BADetailViewController ()

@end

@implementation BADetailViewController

@synthesize appDelegate;
@synthesize searchController;
@synthesize bookList;
@synthesize position;
@synthesize currentEntry;
@synthesize currentDocument;
@synthesize currentLocation;
@synthesize itemsArray;
@synthesize cover;
@synthesize searchedForCover;
@synthesize foundCover;
@synthesize foundPDFToc;
@synthesize didLoadISBD;
@synthesize didReturnFromSegue;
@synthesize computedSizeOfTitleCell;
@synthesize scrollViewController;
@synthesize searchedCoverByISBN;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        [self setFrame:frame];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.itemsArray = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view.
    
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"BAItemDetail" owner:self options:nil];
    [self setView:[xib objectAtIndex:0]];
    
    [((BAItemDetail *)self.view) setFrame:self.frame];
    [((BAItemDetail *)self.view).detailTableView setDelegate:self];
    [((BAItemDetail *)self.view).detailTableView setDataSource:self];

    [self initDetailView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.didReturnFromSegue) {
    } else {
        self.didReturnFromSegue = NO;
    }
}

- (void)initDetailView
{
    self.computedSizeOfTitleCell = 0;
    self.didLoadISBD = NO;
    
    BADocument *document = [[BADocument alloc] init];
    [self setCurrentDocument:document];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    ((BAItemDetail *)self.view).detailTableView.tableFooterView = spinner;
    
    BAConnector *connector = [BAConnector generateConnector];
    if (self.currentEntry.local) {
        [connector getDetailsForLocal:[self.currentEntry ppn] WithDelegate:self];
    } else {
        [connector getDetailsFor:[self.currentEntry ppn] WithDelegate:self];
    }
    BAConnector *unapiConnector = [BAConnector generateConnector];
    [unapiConnector getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"isbd" WithDelegate:self];
    BAConnector *unapiConnectorMods = [BAConnector generateConnector];
    [unapiConnectorMods getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"mods" WithDelegate:self];

    [self.view setNeedsDisplay];
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
    if ([command isEqualToString:@"getDetailsLocal"]) {
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
            [self.currentDocument.items addObject:tempDocumentItem];
        }
        [((BAItemDetail *)self.view).detailTableView reloadData];
        ((BAItemDetail *)self.view).detailTableView.tableFooterView = nil;
    } else if ([command isEqualToString:@"getDetails"]) {
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
            [self.currentDocument.items addObject:tempDocumentItem];
        }
        
        NSMutableArray *tempItems = [[NSMutableArray alloc] init];
        for (BADocumentItem *item in self.currentDocument.items) {
            BADocumentItem *workingItem;
            BOOL foundItem = NO;
            
            if (item.department == nil) {
                [item setDepartment:@"Zusätzliche Exemplare anderer Bibliotheken"];
            }
            
            for (BADocumentItem *tempWorkingItem in tempItems) {
                if (item.department != nil && tempWorkingItem.department != nil) {
                    if ([item.department isEqualToString:tempWorkingItem.department]) {
                        foundItem = YES;
                        workingItem = tempWorkingItem;
                    }
                }
            }
            if (!foundItem) {
                workingItem = [[BADocumentItem alloc] init];
                NSString *tempDepartment;
                if (item.department != nil) {
                    tempDepartment = item.department;
                } else {
                    tempDepartment = @"Zusätzliche Exemplare anderer Bibliotheken";
                }
                [workingItem setDepartment:tempDepartment];
                [workingItem setLabel:item.label];
                [workingItem setLocation:item.location];
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
                NSString *first = [(BADocumentItem*)a department];
                NSString *second = [(BADocumentItem*)b department];
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
        
        [((BAItemDetail *)self.view).detailTableView reloadData];
        ((BAItemDetail *)self.view).detailTableView.tableFooterView = nil;
    } else if ([command isEqualToString:@"getUNAPIDetailsIsbd"]) {
        NSString *resultString = [[NSString alloc] initWithData:(NSData *)result encoding:NSASCIIStringEncoding];
        
        const char *c = [resultString cStringUsingEncoding:NSISOLatin1StringEncoding];
        NSString *newString = [[NSString alloc]initWithCString:c encoding:NSUTF8StringEncoding];
        NSMutableArray *newStringArray = [[newString componentsSeparatedByCharactersInSet: [NSCharacterSet newlineCharacterSet]] mutableCopy];
        
        NSMutableString *displayString = [[NSMutableString alloc] initWithFormat:@""];
        
        int currentLine = 0;
        
        if ([newStringArray count] > currentLine) {
            NSRegularExpression *regexLine = [NSRegularExpression regularExpressionWithPattern:@"^\\[.*\\]" options:NSRegularExpressionCaseInsensitive error:nil];
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
                    [newStringArray setObject:[resultPartsBracket objectAtIndex:1] atIndexedSubscript:currentLine];
                } else {
                    [newStringArray setObject:@"" atIndexedSubscript:currentLine];
                }
            }
            NSArray *resultPartsSlash = [[newStringArray objectAtIndex:currentLine] componentsSeparatedByString:@" / "];
            if ([resultPartsSlash count] > 1) {
                [displayString appendString:[resultPartsSlash objectAtIndex:1]];
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
        
        [self.currentEntry setInfoText:displayString];
        self.didLoadISBD = YES;
        [((BAItemDetail *)self.view).detailTableView reloadData];
        
        [((BAItemDetail *)self.view).detailTableView beginUpdates];
        [((BAItemDetail *)self.view).detailTableView reloadRowsAtIndexPaths:0 withRowAnimation:UITableViewRowAnimationNone];
        [((BAItemDetail *)self.view).detailTableView endUpdates];
        
    } else if ([command isEqualToString:@"getUNAPIDetailsMods"]) {
        GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
        NSArray *modsArray = [parser nodesForXPath:@"_def_ns:mods" error:nil];
        if ([modsArray count] > 0) {
            GDataXMLElement *mods = [modsArray objectAtIndex:0];
            GDataXMLElement *relatedItemToc = (GDataXMLElement *)[[mods elementsForName:@"relatedItem"] objectAtIndex:0];
            [self.currentEntry setTocArray:[[NSMutableArray alloc] init]];
            if (relatedItemToc != nil) {
                NSArray *locationsToc = [relatedItemToc elementsForName:@"location"];
                if (locationsToc != nil) {
                    for (GDataXMLElement *locationToc in locationsToc) {
                        GDataXMLElement *urlToc = (GDataXMLElement *)[[locationToc elementsForName:@"url"] objectAtIndex:0];
                        if (urlToc != nil) {
                            [self.currentEntry.tocArray addObject:[urlToc stringValue]];
                        }
                    }
                }
            }
            [self.currentEntry setOnlineLocation:nil];
            NSArray *onlineLocations = [mods elementsForName:@"location"];
            for (GDataXMLElement *onlineLocation in onlineLocations) {
               if (onlineLocation != nil) {
                  GDataXMLElement *onlineLocationUrl = (GDataXMLElement *)[[onlineLocation elementsForName:@"url"] objectAtIndex:0];
                  if (onlineLocationUrl != nil) {
                     NSRange rangeValueType = [[[onlineLocationUrl attributeForName:@"usage"] stringValue] rangeOfString:@"primary display" options:NSCaseInsensitiveSearch];
                     if (rangeValueType.length > 0) {
                        [self.currentEntry setOnlineLocation:[onlineLocationUrl stringValue]];
                    }
                  }
               }
            }
           
            [self.currentEntry setIsbn:@""];
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
                        }
                    }
                }
            }
            BAConnector *coverConnector = [BAConnector generateConnector];
            [coverConnector getCoverFor:[self.currentEntry isbn] WithDelegate:self];
            [self setSearchedCoverByISBN:YES];
        }
        [((BAItemDetail *)self.view).detailTableView reloadData];
    } else if ([command isEqualToString:@"accountRequestDocs"]) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
        if ([json count] > 0) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Bestellung / Vormerkung\nerfolgreich"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"Bestellung / Vormerkung\nleider nicht möglich"
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } else if ([command isEqualToString:@"getLocationInfoForUri"]) {
    } else if ([command isEqualToString:@"getCover"]) {
        self.searchedForCover = YES;
        
        BAItemDetailTitleCell *titleCell = (BAItemDetailTitleCell *)[((BAItemDetail *)self.view).detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [titleCell.coverView setContentMode:UIViewContentModeCenter];
        if ([self.currentEntry isKindOfClass:[BAEntryWork class]]) {
            [self setCover:[self.currentEntry mediaIcon]];
        } else {
            [self setCover:[UIImage imageNamed:self.currentEntry.matcode]];
        }
        [((BAItemDetail *)self.view).detailTableView reloadData];
        
        self.foundCover = NO;
        
        UIImage *image = [UIImage imageWithData: (NSData *)result];
        if (image.size.height > 1 && image.size.width > 1) {
            [titleCell.coverView setContentMode:UIViewContentModeScaleAspectFit];
            [self setCover:image];
            [((BAItemDetail *)self.view).detailTableView reloadData];
            self.foundCover = YES;
        } else {
            if (self.searchedCoverByISBN) {
                BAConnector *coverConnector = [BAConnector generateConnector];
                [coverConnector getCoverFor:[self.currentEntry ppn] WithDelegate:self];
                [self setSearchedCoverByISBN:NO];
            }
            self.foundCover = NO;
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        BAItemDetailTitleCell *cell = (BAItemDetailTitleCell *) [tableView dequeueReusableCellWithIdentifier:@"BAItemDetailTitleCell"];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAItemDetailTitleCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        // Keep code for profiling
        /*
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAItemDetailTitleCell" owner:self options:nil];
        BAItemDetailTitleCell *cell = [nib objectAtIndex:0];
        */
         
        if (![self.currentEntry isKindOfClass:[BAEntryWork class]]) {
            BAEntryWork *tempEntry = [[BAEntryWork alloc] init];
            [tempEntry setPpn:[self.currentEntry ppn]];
            [tempEntry setTitle:[self.currentEntry title]];
            [tempEntry setSubtitle:[self.currentEntry subtitle]];
            [tempEntry setMatstring:[self.currentEntry matstring]];
            [tempEntry setMatcode:[self.currentEntry matcode]];
            [tempEntry setLocal:[self.currentEntry local]];
            [self setCurrentEntry:tempEntry];
        }
        
        float top = 10;
        
        [cell.titleLabel setText:self.currentEntry.title];
        [cell.titleLabel setFrame: CGRectMake(102,top,208,50)];
        [cell.titleLabel sizeToFit];
        if (cell.titleLabel.frame.size.height > 50) {
            [cell.titleLabel setFrame: CGRectMake(102,top,208,50)];
        } else {
            if ((50 - cell.titleLabel.frame.size.height) > 5) {
                top += 5;
            } else {
                top += (50 - cell.titleLabel.frame.size.height);
            }
        }
        
        if (![self.currentEntry.subtitle isEqualToString:@""]) {
            top += cell.titleLabel.frame.size.height;
            [cell.subTitleLabel setText:self.currentEntry.subtitle];
            [cell.subTitleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [cell.subTitleLabel setFrame: CGRectMake(102,top,208,50)];
            [cell.subTitleLabel sizeToFit];
            if (cell.subTitleLabel.frame.size.height > 15) {
                [cell.subTitleLabel setFrame: CGRectMake(102,top,208,50)];
            } else {
                if ((50 - cell.subTitleLabel.frame.size.height) > 5) {
                    top += 5;
                } else {
                    top += (50 - cell.subTitleLabel.frame.size.height);
                }
            }
        } else {
            [cell.subTitleLabel setText:@""];
        }
        top += cell.subTitleLabel.frame.size.height;
        
        if (self.didLoadISBD) {
            [cell.isbdIndicator stopAnimating];
            [cell.infoLabel setText:self.currentEntry.infoText];
            [cell.infoLabel setFrame: CGRectMake(102,top,208,75)];
            [cell.infoLabel sizeToFit];
            if (cell.infoLabel.frame.size.height > 75) {
                [cell.infoLabel setFrame: CGRectMake(102,top,208,75)];
            }
        } else {
            [cell.infoLabel setText:@""];
            [cell.infoLabel setFrame: CGRectMake(102,top,208,75)];
        }
        top += cell.infoLabel.frame.size.height + 5;
        
        if ([self.currentEntry isKindOfClass:[BAEntryWork class]]) {
            [cell.coverView setImage:[self.currentEntry mediaIcon]];
        } else {
            [cell.coverView setImage:[UIImage imageNamed:self.currentEntry.matcode]];
        }
        
        if (self.foundCover) {
            [cell.coverView setImage:self.cover];
            [cell.coverView setUserInteractionEnabled:YES];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap)];
            [tap setNumberOfTouchesRequired:1];
            [tap setNumberOfTapsRequired:1];
            [tap setDelegate:self];
            [cell.coverView addGestureRecognizer:tap];
        } else {
            [cell.coverView setContentMode:UIViewContentModeCenter];
        }
        
        if (self.searchedForCover) {
            [cell.converIndicator stopAnimating];
        }
        
        [cell.tocInfo addTarget:self action:@selector(tocAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.toc addTarget:self action:@selector(tocAction) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.currentEntry.tocArray count] > 0) {
            if (self.didLoadISBD) {
                if (top < 120) {
                    top = 120;
                }
                [cell.tocInfo setFrame: CGRectMake(10,top,18,19)];
                [cell.toc setFrame: CGRectMake(36,top+1,122,18)];
                [cell.tocInfo setHidden:NO];
                [cell.toc setHidden:NO];
                top += 20;
            }
        }
        
        if (top < 120) {
            top = 120;
        }
        
        [cell.loanInfo addTarget:self action:@selector(loanAction) forControlEvents:UIControlEventTouchUpInside];
        [cell.loan addTarget:self action:@selector(loanAction) forControlEvents:UIControlEventTouchUpInside];
        
        if (!self.currentEntry.local) {
            if (self.didLoadISBD) {
                if (top < 120) {
                    top = 120;
                }
                [cell.loanInfo setFrame: CGRectMake(10,top,18,19)];
                [cell.loan setFrame: CGRectMake(36,top+1,122,18)];
                [cell.loanInfo setHidden:NO];
                [cell.loan setHidden:NO];
                top += 20;
            }
        }
        
        if (top < 120) {
            top = 120;
        }
        
        [cell setFrame: CGRectMake(0,0,320,top+10)];
        self.computedSizeOfTitleCell = top+10;
        
        return cell;
    } else {
        if (self.currentEntry.local) {
            BADocumentItemElementCell *cell = (BADocumentItemElementCell *) [tableView dequeueReusableCellWithIdentifier:@"BADocumentItemElementCell"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BADocumentItemElementCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            // Keep code for profiling
            /*
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BADocumentItemElementCell" owner:self options:nil];
            BADocumentItemElementCell *cell = [nib objectAtIndex:0];
            */
             
            BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:[indexPath row]];
            
            if (self.currentEntry.onlineLocation == nil) {
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
                [cell.title setText:self.currentEntry.onlineLocation];
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
            
            if (loan.available) {
                [cell.status setTextColor:[[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
                [status appendString:@"ausleihbar"];
                
                if (presentation.limitation != nil) {
                    [status appendString:[[NSString alloc] initWithFormat:@"; %@", presentation.limitation]];
                }
                
                if (presentation.available) {
                    if (loan.href == nil) {
                        [statusInfo appendString:@"Bitte am Standort entnehmen"];
                    } else {
                        [statusInfo appendString:@"Bitte bestellen"];
                    }
                }
            } else {
                if (loan.href != nil) {
                    NSRange match = [loan.href rangeOfString: @"loan/RES"];
                    if (match.length > 0) {
                        [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
                        [status appendString:@"ausleihbar"];
                    } else {
                        [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.00 alpha:1.0]];
                        [status appendString:@"nicht ausleihbar"];
                    }
                } else {
                    if (self.currentEntry.onlineLocation == nil) {
                        [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.00 alpha:1.0]];
                        [status appendString:@"nicht ausleihbar"];
                    } else {
                        [status appendString:@"Online-Ressource im Browser öffnen"];
                    }
                }
                if (presentation.limitation != nil) {
                    [status appendString:[[NSString alloc] initWithFormat:@"; %@", presentation.limitation]];
                }
                
                if (!presentation.available) {
                    if (loan.href == nil) {
                        [statusInfo appendString:@"..."];
                    } else {
                        NSRange match = [loan.href rangeOfString: @"loan/RES"];
                        if (match.length > 0) {
                            if ([loan.expected isEqualToString:@""] || [loan.expected isEqualToString:@"unknown"]) {
                                [statusInfo appendString:@"ausgeliehen, Vormerken möglich"];
                            } else {
                                NSString *year = [loan.expected substringWithRange: NSMakeRange (0, 4)];
                                NSString *month = [loan.expected substringWithRange: NSMakeRange (5, 2)];
                                NSString *day = [loan.expected substringWithRange: NSMakeRange (8, 2)];
                                [statusInfo appendString:[[NSString alloc] initWithFormat:@"ausgeliehen bis %@.%@.%@, Vormerken möglich", day, month, year]];
                            }
                        }
                    }
                }
            }
            [cell.status setText:status];
            [cell.statusInfo setText:statusInfo];
            
            if (indexPath.row % 2) {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.title.backgroundColor = [UIColor whiteColor];
                cell.subtitle.backgroundColor = [UIColor whiteColor];
                cell.status.backgroundColor = [UIColor whiteColor];
                cell.statusInfo.backgroundColor = [UIColor whiteColor];
            }else {
                cell.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.title.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.subtitle.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.status.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.statusInfo.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            }
            
            return cell;
        } else {
            BADocumentItemElementCellNonLocal *cell = (BADocumentItemElementCellNonLocal *) [tableView dequeueReusableCellWithIdentifier:@"BADocumentItemElementCellNonLocal"];
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BADocumentItemElementCellNonLocal" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            // Keep code for profiling
            /*
             NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BADocumentItemElementCellNonLocal" owner:self options:nil];
             BADocumentItemElementCellNonLocal *cell = [nib objectAtIndex:0];
             */
            
            BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:[indexPath row]];
            
            [cell.title setText:tempDocumentItem.department];
            [cell.labels setText:tempDocumentItem.label];
            
            if (indexPath.row % 2) {
                cell.contentView.backgroundColor = [UIColor whiteColor];
                cell.title.backgroundColor = [UIColor whiteColor];
                cell.labels.backgroundColor = [UIColor whiteColor];
            }else {
                cell.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.title.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                cell.labels.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:indexPath.row];
        
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
        
        NSMutableString *orderString = [[NSMutableString alloc] init];
        if (self.currentEntry.onlineLocation == nil) {
            if (loan.available) {
                if (presentation.available) {
                    if (loan.href != nil) {
                        [orderString appendString:@"Bestellen"];
                    }
                }
            } else {
                if (!presentation.available) {
                    if (loan.href != nil) {
                        [orderString appendString:@"Vormerken"];
                    }
                }
            }
            UIActionSheet *action;
            if (tempDocumentItem.order) {
                if (tempDocumentItem.location != nil) {
                    action = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Abbrechen"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:orderString, @"Standortinfo", nil];
                } else {
                    action = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Abbrechen"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:orderString, nil];
                }
            } else {
                action = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Abbrechen"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"Standortinfo", nil];
            }
            [action setTag:indexPath.row+1];
            if (![orderString isEqualToString:@""] || (tempDocumentItem.location != nil)) {
                [action showInView:self.scrollViewController.parentViewController.parentViewController.view];
            }
        } else {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"Abbrechen"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"Im Browser öffnen", nil];
            [action setTag:indexPath.row+1];
            [action showInView:self.scrollViewController.parentViewController.parentViewController.view];

        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else {
        return [self.currentDocument.items count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (self.computedSizeOfTitleCell == 0) {
            return 215;
        } else {
            return computedSizeOfTitleCell;
        }
    } else {
        if (self.currentEntry.local) {
            return 87;
        } else {
            return 43;
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (void)actionButton
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:@"Abbrechen"
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"Zur Merkliste hinzufügen", nil];
    [action setTag:0];
    [action showInView:self.scrollViewController.parentViewController.parentViewController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 0) {
        if (buttonIndex == 0) {
            NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BAEntry" inManagedObjectContext:[self.appDelegate managedObjectContext]];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDescription];
            
            NSError *error = nil;
            NSArray *tempEntries = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
            BOOL foundPpn = NO;
            for (BAEntry *tempExistingEntry in tempEntries) {
                if ([self.currentEntry.ppn isEqualToString:tempExistingEntry.ppn]) {
                    foundPpn = YES;
                }
            }
            
            if (!foundPpn) {
                BAEntry *newEntry = (BAEntry *)[NSEntityDescription insertNewObjectForEntityForName:@"BAEntry" inManagedObjectContext:[self.appDelegate managedObjectContext]];
                [newEntry setTitle:self.currentEntry.title];
                [newEntry setSubtitle:self.currentEntry.subtitle];
                [newEntry setPpn:self.currentEntry.ppn];
                [newEntry setMatstring:self.currentEntry.matstring];
                [newEntry setMatcode:self.currentEntry.matcode];
                [newEntry setLocal:self.currentEntry.local];
                [newEntry setAuthor:self.currentEntry.author];
                NSError *error = nil;
                if (![[self.appDelegate managedObjectContext] save:&error]) {
                    // Handle the error.
                }
                [self.scrollViewController.listButton setEnabled:NO];
            } else {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"Der Eintrag befindet sich bereits auf Ihrer Merkliste"
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
    } else if (actionSheet.tag > 0) {
        NSInteger itemIndex = actionSheet.tag-1;
        if (buttonIndex == 0) {
            if ([[(UIButton *)[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] currentTitle] isEqualToString:@"Bestellen"] || [[(UIButton *)[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] currentTitle] isEqualToString:@"Vormerken"]) {
                if (self.appDelegate.currentAccount != nil && self.appDelegate.currentToken != nil) {
                    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                    [tempArray addObject:[self.currentDocument.items objectAtIndex:itemIndex]];
                    BAConnector *requestConnector = [BAConnector generateConnector];
                    [requestConnector accountRequestDocs:tempArray WithAccount:self.appDelegate.currentAccount WithToken:self.appDelegate.currentToken WithDelegate:self];
                } else {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                    message:@"Sie müssen sich zuerst anmelden. Wechseln Sie dazu bitte in den Bereich Konto"
                                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            } else if ([[(UIButton *)[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] currentTitle] isEqualToString:@"Standortinfo"]) {
                [self.scrollViewController setTempLocation:self.currentLocation];
                [self.scrollViewController performSegueWithIdentifier:@"ItemDetailLocationSegue" sender:self];
            } else if ([[(UIButton *)[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] currentTitle] isEqualToString:@"Im Browser öffnen"]) {
                NSURL *url = [NSURL URLWithString:self.currentEntry.onlineLocation];
                if (![[UIApplication sharedApplication] openURL:url]) {
                }
            }
        } else if (buttonIndex == 1) {
            if ([[(UIButton *)[[actionSheet valueForKey:@"_buttons"] objectAtIndex:1] currentTitle] isEqualToString:@"Standortinfo"]) {
                [self.scrollViewController setTempLocation:self.currentLocation];
                [self.scrollViewController performSegueWithIdentifier:@"ItemDetailLocationSegue" sender:self];
            }
        }
    }
}

- (void)loadCover
{
    self.searchedForCover = YES;
    
    BAItemDetailTitleCell *titleCell = (BAItemDetailTitleCell *)[((BAItemDetail *)self.view).detailTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [titleCell.coverView setContentMode:UIViewContentModeCenter];
    if ([self.currentEntry isKindOfClass:[BAEntryWork class]]) {
        [self setCover:[self.currentEntry mediaIcon]];
    } else {
        [self setCover:[UIImage imageNamed:self.currentEntry.matcode]];
    }
    [((BAItemDetail *)self.view).detailTableView reloadData];
    
    self.foundCover = NO;
}

- (void)coverTap
{
    [self.scrollViewController setTempCover:self.cover];
    [self.scrollViewController performSegueWithIdentifier:@"coverSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.didReturnFromSegue = YES;
    if ([[segue identifier] isEqualToString:@"coverSegue"]) {
        BACoverViewControllerIPhone *coverViewController = (BACoverViewControllerIPhone *)[segue destinationViewController];
        [coverViewController setCoverImage:self.cover];
    } else if ([[segue identifier] isEqualToString:@"tocSegue"]) {
        BATocViewController *tocViewController = (BATocViewController *)[segue destinationViewController];
        [tocViewController setUrl:self.currentEntry.toc];
    } else if ([[segue identifier] isEqualToString:@"ItemDetailLocationSegue"]) {
        BALocationViewControllerIPhone *locationViewController = (BALocationViewControllerIPhone *)[segue destinationViewController];
        [locationViewController setCurrentLocation:self.currentLocation];
    }
}

- (void)tocAction
{
    if (self.currentEntry.tocArray != nil && [self.currentEntry.tocArray count] > 0) {
        [self.scrollViewController setTempTocArray:self.currentEntry.tocArray];
        [self.scrollViewController performSegueWithIdentifier:@"tocListSegue" sender:self];
    }
}

- (void)loanAction
{
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://gso.gbv.de/DB=2.1/PPNSET?PPN=%@", self.currentEntry.ppn]];
    if (![[UIApplication sharedApplication] openURL:url]) {
    }
}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer
{
    if (self.position < [self.bookList count]-1) {
        [self setPosition:self.position+1];
        [self setCurrentEntry:[self.bookList objectAtIndex:self.position]];
        [self initDetailView];
        if (self.position == [self.bookList count]-2) {
            if (self.currentEntry.local) {
                [self.searchController continueSearchFor:@"local"];
            } else {
                [self.searchController continueSearchFor:@"nonLocal"];
            }
        }
    }
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer
{
    if (self.position > 0) {
        [self setPosition:self.position-1];
        [self setCurrentEntry:[self.bookList objectAtIndex:self.position]];
        [self initDetailView];
    }
}

-(void)move:(id)sender
{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)entryOnList
{
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BAEntry" inManagedObjectContext:[self.appDelegate managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    NSArray *tempEntries = [self.appDelegate.managedObjectContext executeFetchRequest:request error:&error];
    BOOL foundPpn = NO;
    for (BAEntry *tempExistingEntry in tempEntries) {
        if ([self.currentEntry.ppn isEqualToString:tempExistingEntry.ppn]) {
            foundPpn = YES;
        }
    }
    
    return foundPpn;
}

- (void)commandIsNotInScope:(NSString *)command {
   // ToDo: reset state if necessary
}

@end
