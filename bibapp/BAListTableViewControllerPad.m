//
//  BAListTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BAAppDelegate.h"
#import "BAListTableViewControllerPad.h"
#import "BADetailViewController.h"
#import "BAItemCell.h"
#import "BAEntry.h"
#import "BAConnector.h"
#import "BADocumentItem.h"
#import "BADocumentItemElement.h"
#import "BADocumentItemElementCellPad.h"
#import "BADocumentItemElementCellNonLocalPad.h"
#import "BACoverViewControllerPad.h"
#import "BALocationViewControllerPad.h"
#import "BATocViewControllerPad.h"
#import "DAIAParser.h"
#import "BALocalizeHelper.h"

#import "GDataXMLNode.h"

@interface BAListTableViewControllerPad ()

@end

@implementation BAListTableViewControllerPad

@synthesize dummyBooksMerkliste;
@synthesize position;
@synthesize currentItem;
@synthesize currentEntry;
@synthesize listTableView;
@synthesize defaultTextView;
@synthesize defaultImageView;
@synthesize currentDocument;
@synthesize didLoadISBD;
@synthesize computedSizeOfTitleCell;
@synthesize cover;
@synthesize searchedForCover;
@synthesize foundCover;
@synthesize currentLocation;
@synthesize tocTableViewController;
@synthesize statusBarTintUIView;
@synthesize optionsButton;

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
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (self.appDelegate.isIOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
        //[self.statusBarTintUIView setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.listNavigationBar setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.detailNavigationBar setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.optionsButton setTintColor:[UIColor whiteColor]];
    } else {
        [self.statusBarTintUIView setHidden:YES];
        [self.listNavigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
        [self.detailNavigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    }
    
    [self setCurrentItem: [[BAEntryWork alloc] init]];
    [self setCurrentEntry: [[BAEntryWork alloc] init]];
    
    self.defaultTextView = [[UITextView alloc] initWithFrame:CGRectMake(320, 139, 704, 75)];
    [self.defaultTextView setFont:[UIFont systemFontOfSize:20]];
    [self.defaultTextView setTextAlignment:NSTextAlignmentCenter];
    [self.defaultTextView setEditable:NO];
    [self.defaultTextView setUserInteractionEnabled:NO];
    [self.defaultTextView setOpaque:YES];
    [self.defaultTextView setBackgroundColor:[UIColor clearColor]];
    [self.defaultTextView setTextColor:[UIColor labelColor]];
    [self.view addSubview:self.defaultTextView];
    
    self.defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(547, 214, 250, 150)];
    [self.defaultImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.defaultImageView setImage:[UIImage imageNamed:@"Buch_250_gradient.png"]];
    [self.view addSubview:self.defaultImageView];
    
    [self initDetailView];
    
    [self.listTableView setTag:0];
    [self.detailTableView setTag:1];
    
    CALayer *leftBorder = [CALayer layer];
    leftBorder.borderColor = [UIColor lightGrayColor].CGColor;
    leftBorder.borderWidth = 1;
    leftBorder.frame = CGRectMake(-1, 0, 1, self.scrollView.frame.size.height+2);
    [self.scrollView.layer addSublayer:leftBorder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverTap)];
    [tap setNumberOfTouchesRequired:1];
    [tap setNumberOfTapsRequired:1];
    [tap setDelegate:self];
    [self.coverView addGestureRecognizer:tap];
    
    self.tocTableViewController = [[BATocTableViewControllerPad alloc] init];
    [self.tocTableViewController setSearchController:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadEntries];
    
    [self.listTableView reloadData];
    
    if ([self.dummyBooksMerkliste count] == 0) {
        [self.trashIcon setEnabled:NO];
    } else {
        [self.trashIcon setEnabled:YES];
    }
    
    [self.listTableView setEditing:NO];
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
    if (tableView.tag == 0) {
        return [self.dummyBooksMerkliste count];
    } else if (tableView.tag == 1) {
        return [self.currentDocument.items count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    BAItemCell *cell;
    if (tableView.tag == 0) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        // Configure the cell...
        BAEntry *entry;
        entry = [self.dummyBooksMerkliste objectAtIndex:indexPath.row];
        [cell.titleLabel setText:entry.title];
        [cell.subtitleLabel setText:entry.subtitle];
        [cell.image setImage:[UIImage imageNamed:entry.matcode]];
        [cell.authorLabel setText:entry.author];
        [cell.yearLabel setText:entry.year];
        return cell;
    } else if (tableView.tag == 1) {
        if(self.currentEntry.local){
            BADocumentItemElementCellPad *cell;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BADocumentItemElementCellPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:[indexPath row]];
            
            if (self.currentEntry.onlineLocation == nil) {
                NSMutableString *titleString = [[NSMutableString alloc] init];
                if (tempDocumentItem.department != nil) {
                    [titleString appendString:tempDocumentItem.department];
                }
                if (tempDocumentItem.storage != nil) {
                    if (![tempDocumentItem.storage isEqualToString:@""]) {
                        [titleString appendFormat:@", %@", tempDocumentItem.storage];
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
                    [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
                    [status appendString:BALocalizedString(@"ausleihbar")];
                } else {
                    if (self.currentEntry.onlineLocation == nil) {
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
           
            if (indexPath.row % 2) {
                //cell.contentView.backgroundColor = [UIColor whiteColor];
                //cell.title.backgroundColor = [UIColor whiteColor];
                //cell.subtitle.backgroundColor = [UIColor whiteColor];
                //cell.status.backgroundColor = [UIColor whiteColor];
                //cell.statusInfo.backgroundColor = [UIColor whiteColor];
            } else {
                //cell.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                //cell.title.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                //cell.subtitle.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                //cell.status.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                //cell.statusInfo.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            }
           
            return cell;
        } else {
            BADocumentItemElementCellNonLocalPad *cell;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BADocumentItemElementCellNonLocalPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
            BADocumentItem *tempDocumentItem = [self.currentDocument.items objectAtIndex:[indexPath row]];
            
            [cell.title setText:tempDocumentItem.department];
            [cell.labels setText:tempDocumentItem.label];
            [cell.actionButton setTag:indexPath.row];
            [cell.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            if (indexPath.row % 2) {
                //cell.contentView.backgroundColor = [UIColor whiteColor];
                //cell.title.backgroundColor = [UIColor whiteColor];
                //cell.labels.backgroundColor = [UIColor whiteColor];
            } else {
                //cell.contentView.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                //cell.title.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
                //cell.labels.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            }
           
            return cell;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        BAEntry *tempEntry = [self.dummyBooksMerkliste objectAtIndex:[indexPath row]];
        
        [self.currentEntry setPpn:[tempEntry ppn]];
        [self.currentEntry setTitle:[tempEntry title]];
        [self.currentEntry setSubtitle:[tempEntry subtitle]];
        [self.currentEntry setMatstring:[tempEntry matstring]];
        [self.currentEntry setMatcode:[tempEntry matcode]];
        [self.currentEntry setLocal:[tempEntry local]];
        
        [self showDetailView];
    } else if (tableView.tag == 1) {
        [self actionButtonClick:[tableView cellForRowAtIndexPath:indexPath]];
    }
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        [[tableView cellForRowAtIndexPath:currentSelectedIndexPath] setBackgroundColor:[UIColor clearColor]];
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.isSelected == YES)
    {
        [cell setBackgroundColor:[UIColor tertiarySystemBackgroundColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)showDetailView
{
    [self.defaultTextView setHidden:YES];
    [self.defaultImageView setHidden:YES];
    
    BAEntryWork *tempEntry;
    tempEntry = self.currentEntry;
    
    if (tempEntry != nil) {
        [self.coverView setHidden:NO];
        [self.titleLabel setHidden:NO];
        [self.subtitleLabel setHidden:NO];
        [self.isbdLabel setHidden:NO];
        [self.detailTableView setHidden:NO];
        
        [self.tocButton addTarget:self action:@selector(tocAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tocTitleButton addTarget:self action:@selector(tocAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.tocButton setHidden:YES];
        [self.tocTitleButton setHidden:YES];
        if (self.currentEntry.toc != nil) {
            [self.tocButton setHidden:NO];
            [self.tocTitleButton setHidden:NO];
        }
        
        [self.loanButton addTarget:self action:@selector(loanAction) forControlEvents:UIControlEventTouchUpInside];
        [self.loanTitleButton addTarget:self action:@selector(loanAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self.loanButton setHidden:YES];
        [self.loanTitleButton setHidden:YES];
        if (!self.currentEntry.local) {
            [self.loanButton setHidden:NO];
            [self.loanTitleButton setHidden:NO];
        }
        
        [self.titleLabel setText:tempEntry.title];
        [self.subtitleLabel setText:tempEntry.subtitle];
        
        self.computedSizeOfTitleCell = 0;
        self.didLoadISBD = NO;
        
        [self.isbdLabel setText:self.currentEntry.infoText];
        
        BADocument *document = [[BADocument alloc] init];
        [self setCurrentDocument:document];
        
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, 320, 44);
        self.detailTableView.tableFooterView = spinner;
        
        BAConnector *connector = [BAConnector generateConnector];
        BAConnector *unapiConnector = [BAConnector generateConnector];
        BAConnector *unapiConnectorMods = [BAConnector generateConnector];
        
        if (self.currentEntry.local) {
            if ([self.appDelegate.configuration.currentBibBlockOrderTypes count] == 0) {
                [connector getDetailsForLocal:[self.currentEntry ppn] WithDelegate:self];
            } else {
                BAConnector *unapiConnectorPica = [BAConnector generateConnector];
                [unapiConnectorPica getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"picaxml" WithDelegate:self];
            }
            [unapiConnector getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"isbd" WithDelegate:self];
            [unapiConnectorMods getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"mods" WithDelegate:self];
        } else {
            [connector getDetailsFor:[self.currentEntry ppn] WithDelegate:self];
            [unapiConnector getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"isbd" WithDelegate:self];
            [unapiConnectorMods getUNAPIDetailsFor:[self.currentEntry ppn] WithFormat:@"mods" WithDelegate:self];
        }
        
        [self.coverView setImage:nil];
    } else {
        [self initDetailView];
    }
}

- (void)loadCover
{
    if ([self.currentEntry isKindOfClass:[BAEntryWork class]]) {
        [self setCover:[self.currentEntry mediaIcon]];
    } else {
        [self setCover:[UIImage imageNamed:self.currentEntry.matcode]];
    }
    
    [self.coverView setContentMode:UIViewContentModeCenter];
    [self.coverView setImage:self.currentEntry.mediaIcon];
    
    NSString *urlStringISBN;
    urlStringISBN = [[NSString alloc] initWithFormat:@"http://ws.gbv.de/covers/?id=%@&format=img", [self.currentEntry isbn]];
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
        urlStringPPN = [[NSString alloc] initWithFormat:@"http://ws.gbv.de/covers/?id=%@&format=img", [self.currentEntry ppn]];
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
}


- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
    if ([command isEqualToString:@"getDetailsLocal"]) {
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
            
            if (item.department == nil) {
                [item setDepartment:BALocalizedString(@"Zusätzliche Exemplare anderer Bibliotheken")];
            }
            
            for (BADocumentItem *tempWorkingItem in tempItems) {
                if(item.department != nil && tempWorkingItem.department != nil){
                    if([item.department isEqualToString:tempWorkingItem.department]){
                        foundItem = YES;
                        workingItem = tempWorkingItem;
                    }
                }
            }
            if (!foundItem) {
                workingItem = [[BADocumentItem alloc] init];
                NSString *tempDepartment;
                if(item.department != nil){
                    tempDepartment = item.department;
                } else {
                    tempDepartment = BALocalizedString(@"Zusätzliche Exemplare anderer Bibliotheken");
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
       
        for (int i = currentLine; i < [newStringArray count]-1; i++) {
           NSString *tempString = [newStringArray objectAtIndex:i];
           if ([tempString hasPrefix:@"In: "] || [tempString hasPrefix:@"Enthalten in: "]) {
              if (![displayString isEqualToString:@""]) {
                 [displayString appendString:@"\n"];
              }
              [displayString appendString:tempString];
           }
        }
       
        [self.isbdLabel setText:displayString];
        [self.currentItem setInfoText:displayString];
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
        }
        if([self.currentEntry.tocArray count] > 0){
            [self.tocButton setHidden:NO];
            [self.tocTitleButton setHidden:NO];
            [self.tocTableViewController.tocArray removeAllObjects];
            [self.tocTableViewController.tocArray addObjectsFromArray:self.currentEntry.tocArray];
        }
        [self loadCover];
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
            [connector getDetailsForLocal:[self.currentEntry ppn] WithDelegate:self];
        } else {
            if (self.appDelegate.configuration.useDAIASubRequests) {
                [connector getDetailsForLocalFam:[self.currentEntry ppn] WithStart:self.currentDaiaFamIndex WithDelegate:self];
            }
        }
    } else if ([command isEqualToString:@"accountRequestDocs"]) {
        if ([self.appDelegate.configuration usePAIAWrapper]) {
           NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
            
           NSString *message = nil;
           if ([json count] > 0) {
              message = BALocalizedString(@"Bestellung / Vormerkung\nerfolgreich");
           } else {
              message = BALocalizedString(@"Bestellung / Vormerkung\nleider nicht möglich");
           }
            
           UIAlertController * alertError = [UIAlertController
                               alertControllerWithTitle:nil
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];

           UIAlertAction* okAction = [UIAlertAction
                                       actionWithTitle:BALocalizedString(@"Ok")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                               }];

           [alertError addAction:okAction];
           [self presentViewController:alertError animated:YES completion:nil];
        } else {
           NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
            
           NSString *message = nil;
           if ([json objectForKey:@"error"] == nil && [json objectForKey:@"doc"] != nil) {
              NSDictionary *doc = [[json objectForKey:@"doc"] objectAtIndex:0];
              if ([doc objectForKey:@"error"] == nil) {
                 message = BALocalizedString(@"Bestellung / Vormerkung\nerfolgreich");
              } else {
                 message = [[NSString alloc] initWithFormat:BALocalizedString(@"Bestellung / Vormerkung\nleider nicht möglich:\n%@"), [doc objectForKey:@"error"]];
              }
           } else {
              message = [[NSString alloc] initWithFormat:BALocalizedString(@"Bestellung / Vormerkung\nleider nicht möglich:\n%@"), [json objectForKey:@"error_description"]];
           }
            
           UIAlertController * alertError = [UIAlertController
                                alertControllerWithTitle:nil
                                                 message:message
                                          preferredStyle:UIAlertControllerStyleAlert];

           UIAlertAction* okAction = [UIAlertAction
                                        actionWithTitle:BALocalizedString(@"Ok")
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                }];

           [alertError addAction:okAction];
           [self presentViewController:alertError animated:YES completion:nil];
        }
    } else if ([command isEqualToString:@"getDetailsLocalFam"]) {
        GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
        
        NSArray *items = [parser nodesForXPath:@"RESULT/SET/SHORTTITLE" error:nil];
        if ([items count] > 0) {
            for (GDataXMLElement *item in items) {
                NSString *ppn = [[item attributeForName:@"PPN"] stringValue];
                
                NSLog(@"PPN: %@", ppn);
                
                if (![ppn isEqualToString:self.currentEntry.ppn]) {
                    BAConnector *connector = [BAConnector generateConnector];
                    [connector getDetailsForLocal:ppn WithDelegate:self];
                }
            }
        } else {
            BAConnector *connector = [BAConnector generateConnector];
            [connector getDetailsForLocal:[self.currentEntry ppn] WithDelegate:self];
        }
        
        NSArray *sets = [parser nodesForXPath:@"RESULT/SET" error:nil];
        for (GDataXMLElement *set in sets) {
            if ([[[set attributeForName:@"hits"] stringValue] longLongValue] > (self.currentDaiaFamIndex + 10) ) {
                self.currentDaiaFamIndex += 10;
                BAConnector *famConnector = [BAConnector generateConnector];
                [famConnector getDetailsForLocalFam:[self.currentEntry ppn] WithStart:self.currentDaiaFamIndex WithDelegate:self];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete) {
        BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSManagedObject *entryToDelete = [[self dummyBooksMerkliste] objectAtIndex:indexPath.row];
        [appDelegate.managedObjectContext deleteObject:entryToDelete];
        NSError *error = nil;
        if (![[appDelegate managedObjectContext] save:&error]) {
            // Handle the error.
        }
        [self loadEntries];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [self.listTableView reloadData];
        [self initDetailView];
      
        if ([self.dummyBooksMerkliste count] == 0) {
            [self.trashIcon setEnabled:NO];
        }
	}
}

- (void)loadEntries
{
    self.dummyBooksMerkliste = [[NSArray alloc] init];
    
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"BAEntry" inManagedObjectContext:[appDelegate managedObjectContext]];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error = nil;
    [self setDummyBooksMerkliste: [appDelegate.managedObjectContext executeFetchRequest:request error:&error]];
    
    if ([self dummyBooksMerkliste] == nil) {
        // Deal with error...
    }
}

- (IBAction)trashAction:(id)sender
{
    if (!self.listTableView.editing) {
        [self.listTableView setEditing:YES animated:YES];
    } else {
        [self.listTableView setEditing:NO animated:YES];
    }
}

- (void)initDetailView
{
    [self.coverView setHidden:YES];
    [self.titleLabel setHidden:YES];
    [self.subtitleLabel setHidden:YES];
    [self.isbdLabel setHidden:YES];
    [self.tocButton setHidden:YES];
    [self.tocTitleButton setHidden:YES];
    [self.loanButton setHidden:YES];
    [self.loanTitleButton setHidden:YES];
    [self.detailTableView setHidden:YES];
    
    [self.defaultTextView setHidden:NO];
    [self.defaultImageView setHidden:NO];

    [self.defaultTextView setText:BALocalizedString(@"Merkliste")];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        return 73.0;
    } else {
        if (self.currentEntry.local) {
            return 87;
        } else {
            return 43;
        }
    }
}

- (void)showLocation
{
    [self performSegueWithIdentifier:@"locationSegue" sender:self];
}

- (void)displayToc {
   [self dismissViewControllerAnimated:YES completion:nil];
   [self performSelector: @selector(showToc) withObject: nil afterDelay: 0];
}

- (IBAction)actionAction:(id)sender {
   NSMutableString *messageBody = [[NSMutableString alloc] init];
   BAConnector *isbdConnector = [BAConnector generateConnector];
   int counter = 1;
   for (BAEntry *tempEntry in self.dummyBooksMerkliste) {
      if (counter > 1) {
         [messageBody appendFormat:@"\n\n"];
      }
      [messageBody appendFormat:@"%d) %@", counter, [isbdConnector loadISBDWithPPN:tempEntry.ppn]];
      counter++;
   }
   if ([MFMailComposeViewController canSendMail]) {
      MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
      [composeViewController setMailComposeDelegate:self];
      [composeViewController setToRecipients:@[@""]];
      [composeViewController setSubject:BALocalizedString(@"BibApp Merkliste")];
      [composeViewController setMessageBody:messageBody isHTML:NO];
      [self presentViewController:composeViewController animated:YES completion:NULL];
   }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
   //Add an alert in case of failure
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showToc{
   [self performSegueWithIdentifier:@"tocSegue" sender:self];
}

- (void)coverTap
{
    [self performSegueWithIdentifier:@"coverSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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

- (void)actionButtonClick:(id)sender
{
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
    tempEntry = self.currentEntry;
    
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
        UIAlertController *alert = [UIAlertController
                         alertControllerWithTitle:nil
                                          message:nil
                                   preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction* cancelAction = [UIAlertAction
                                 actionWithTitle:BALocalizedString(@"Abbrechen")
                                           style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction * action) {
                                         }];
        [alert addAction:cancelAction];
        
        if (tempDocumentItem.order) {
            if (tempDocumentItem.location != nil) {
                UIAlertAction* orderAction = [UIAlertAction
                                         actionWithTitle:orderString
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                    if (self.appDelegate.currentAccount != nil && self.appDelegate.currentToken != nil) {
                                                        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                                                        [tempArray addObject:[self.currentDocument.items objectAtIndex:clicked.tag]];
                                                        BAConnector *requestConnector = [BAConnector generateConnector];
                                                        [requestConnector accountRequestDocs:tempArray WithAccount:self.appDelegate.currentAccount WithToken:self.appDelegate.currentToken WithDelegate:self];
                                                    } else {
                                                        UIAlertController * alertError = [UIAlertController
                                                                             alertControllerWithTitle:nil
                                                                                              message:BALocalizedString(@"Sie müssen sich zuerst anmelden. Wechseln Sie dazu bitte in den Bereich Konto")
                                                                                       preferredStyle:UIAlertControllerStyleAlert];

                                                        UIAlertAction* okAction = [UIAlertAction
                                                                                     actionWithTitle:BALocalizedString(@"Ok")
                                                                                               style:UIAlertActionStyleDefault
                                                                                             handler:^(UIAlertAction * action) {
                                                                                             }];

                                                        [alertError addAction:okAction];
                                                        [self presentViewController:alertError animated:YES completion:nil];
                                                    }
                                                 }];
                [alert addAction:orderAction];
                
                UIAlertAction* locationAction = [UIAlertAction
                                         actionWithTitle:BALocalizedString(@"Standortinfo")
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                    [self performSelector: @selector(showLocation) withObject: nil afterDelay: 0];
                                                 }];
                [alert addAction:locationAction];
            } else {
                UIAlertAction* orderAction = [UIAlertAction
                                         actionWithTitle:orderString
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                    if (self.appDelegate.currentAccount != nil && self.appDelegate.currentToken != nil) {
                                                        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                                                        [tempArray addObject:[self.currentDocument.items objectAtIndex:clicked.tag]];
                                                        BAConnector *requestConnector = [BAConnector generateConnector];
                                                        [requestConnector accountRequestDocs:tempArray WithAccount:self.appDelegate.currentAccount WithToken:self.appDelegate.currentToken WithDelegate:self];
                                                    } else {
                                                        UIAlertController * alertError = [UIAlertController
                                                                             alertControllerWithTitle:nil
                                                                                              message:BALocalizedString(@"Sie müssen sich zuerst anmelden. Wechseln Sie dazu bitte in den Bereich Konto")
                                                                                       preferredStyle:UIAlertControllerStyleAlert];

                                                        UIAlertAction* okAction = [UIAlertAction
                                                                                     actionWithTitle:BALocalizedString(@"Ok")
                                                                                               style:UIAlertActionStyleDefault
                                                                                             handler:^(UIAlertAction * action) {
                                                                                             }];

                                                        [alertError addAction:okAction];
                                                        [self presentViewController:alertError animated:YES completion:nil];
                                                    }
                                                 }];
                [alert addAction:orderAction];
            }
        } else {
            UIAlertAction* locationAction = [UIAlertAction
                                     actionWithTitle:BALocalizedString(@"Standortinfo")
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action) {
                                                [self performSelector: @selector(showLocation) withObject: nil afterDelay: 0];
                                             }];
            [alert addAction:locationAction];
        }
        //CGRect cellRect = [self.detailTableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:clicked.tag inSection:0]];
        if (self.currentEntry.local) {
            //[action showFromRect:CGRectMake(cellRect.origin.x+625, cellRect.origin.y-7, 200, 100) inView:self.detailTableView animated:YES];
            //[action showFromRect:CGRectMake(cellRect.origin.x, cellRect.origin.y, 200, 100) inView:self.detailTableView animated:YES];
        } else {
            //[action showFromRect:CGRectMake(cellRect.origin.x+625, cellRect.origin.y-28, 200, 100) inView:self.detailTableView animated:YES];
            //[action showFromRect:CGRectMake(cellRect.origin.x, cellRect.origin.y, 200, 100) inView:self.detailTableView animated:YES];
        }
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        UIAlertController *alert = [UIAlertController
                         alertControllerWithTitle:nil
                                          message:nil
                                   preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction* cancelAction = [UIAlertAction
                                 actionWithTitle:BALocalizedString(@"Abbrechen")
                                           style:UIAlertActionStyleCancel
                                         handler:^(UIAlertAction * action) {
                                         }];
        
        UIAlertAction* openAction = [UIAlertAction
                                 actionWithTitle:BALocalizedString(@"Im Browser öffnen")
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                            NSURL *url = [NSURL URLWithString:self.currentEntry.onlineLocation];
                                            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                                         }];

        [alert addAction:cancelAction];
        [alert addAction:openAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)tocAction:(id)sender{
    [self setModalPresentationStyle:UIModalPresentationPopover];
    [self presentViewController:self.tocTableViewController animated:YES completion:nil];
}

- (void)loanAction
{
    NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"http://gso.gbv.de/DB=2.1/PPNSET?PPN=%@", self.currentEntry.ppn]];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

- (BOOL)shouldAutorotate
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];

    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        return YES;
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        return YES;
    } else {
        return NO;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)commandIsNotInScope:(NSString *)command {
   // ToDo: reset state if necessary
}

- (void)networkIsNotReachable:(NSString *)command {
   // ToDo: reset state if necessary
}

@end
