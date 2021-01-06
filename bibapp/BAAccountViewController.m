//
//  BAAccountViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 28.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAAppDelegate.h"
#import "BAAccountViewController.h"
#import "BAEntryWork.h"
#import "BAItemAccountCell.h"
#import "BAConnector.h"
#import "BAFee.h"
#import "BAFeeCell.h"
#import "BAAccountTableHeaderTextView.h"
#import "GDataXMLNode.h"
#import "BALocalizeHelper.h"
#import "BAIdViewController.h"

@interface BAAccountViewController ()

@end

@implementation BAAccountViewController

@synthesize appDelegate;
@synthesize loan;
@synthesize reservation;
@synthesize interloan;
@synthesize feesSum;
@synthesize fees;
@synthesize sendEntries;
@synthesize successfulEntriesWrapper;
@synthesize successfulEntries;
@synthesize currentAccount;
@synthesize currentPassword;
@synthesize currentToken;
@synthesize currentScope;
@synthesize accountTableView;
@synthesize accountSegmentedController;
@synthesize refreshControl;

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
	// Do any additional setup after loading the view.
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController.navigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    self.loan = [[NSMutableArray alloc] init];
    self.reservation = [[NSMutableArray alloc] init];
    self.interloan = [[NSMutableArray alloc] init];
    self.feesSum = [[NSMutableArray alloc] init];
    self.fees = [[NSMutableArray alloc] init];
    
    [self.accountSegmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    [self.accountSegmentedController setTintColor:self.appDelegate.configuration.currentBibTintColor];
    [self.accountSegmentedController setTitle:BALocalizedString(@"Ausgeliehen") forSegmentAtIndex:0];
    [self.accountSegmentedController setTitle:BALocalizedString(@"Vorgemerkt") forSegmentAtIndex:1];
    [self.accountSegmentedController setTitle:BALocalizedString(@"Gebühren") forSegmentAtIndex:2];
    
    [self setRefreshControl:[[UIRefreshControl alloc] init]];
    [self.refreshControl addTarget:self action:@selector(refreshLoanAndReservation:) forControlEvents:UIControlEventValueChanged];
    [self.accountTableView addSubview:self.refreshControl];
    
    self.idButton.enabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BAConnector *checkNetworkReachabilityConnector = [BAConnector generateConnector];
    if ([checkNetworkReachabilityConnector checkNetworkReachability]) {
       if (!self.appDelegate.isLoggedIn) {
           [self.navigationController.navigationBar.topItem setTitle:BALocalizedString(@"Konto")];
           [self setCurrentAccount:nil];
           [self setCurrentPassword:nil];
           [self setCurrentScope:nil];
           [self setCurrentToken:nil];
           [self loginActionWithMessage:@""];
       } else {
           [self setSuccessfulEntriesWrapper:[[NSMutableArray alloc] init]];
           [self.successfulEntriesWrapper removeAllObjects];
           [self setSuccessfulEntries:[[NSMutableDictionary alloc] init]];
           [self.successfulEntries removeAllObjects];
           [self.sendEntries removeAllObjects];
           [self.actionButton setEnabled:YES];
           //UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
           //[spinner startAnimating];
           //spinner.frame = CGRectMake(0, 0, 320, 44);
           //self.accountTableView.tableHeaderView = spinner;
           [self.refreshControl beginRefreshing];
           [self.accountTableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:NO];
           BAConnector *accountLoanConnector = [BAConnector generateConnector];
           [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
           BAConnector *accountFeesConnector = [BAConnector generateConnector];
           [accountFeesConnector accountLoadFeesWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
       }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
            self.isLoggingIn = NO;
            //self.accountTableView.tableHeaderView = nil;
        } else if (buttonIndex == 1) {
            [self setCurrentAccount:[[alertView textFieldAtIndex:0] text]];
            [self setCurrentPassword:[[alertView textFieldAtIndex:1] text]];
            if (self.appDelegate.options.saveLocalData) {
                [self.appDelegate.account setAccount:[[alertView textFieldAtIndex:0] text]];
                [self.appDelegate.account setPassword:[[alertView textFieldAtIndex:1] text]];
                if (![[self.appDelegate managedObjectContext] save:nil]) {
                    // Handle the error.
                }
            }
            BAConnector *accountConnector = [BAConnector generateConnector];
            [accountConnector loginWithAccount:[[alertView textFieldAtIndex:0] text] WithPassword:[[alertView textFieldAtIndex:1] text] WithDelegate:self];
        }
    }
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:&error];
    if ([json count] > 0) {
        BOOL foundError = NO;
        if (![json isKindOfClass:[NSMutableArray class]]) {
            NSEnumerator *enumerator = [json keyEnumerator];
            id key;
            while ((key = [enumerator nextObject])) {
                if ([key isEqualToString:@"error"]) {
                    foundError = YES;
                }
            }
        }
        if (foundError) {
           if (![command isEqualToString:@"login"]) {
              //NSString *errorCode = [[json objectForKey:@"code"] stringValue];
              NSString *errorCode = [json objectForKey:@"code"];
              if (![errorCode isKindOfClass:[NSString class]]) {
                 errorCode = [[json objectForKey:@"code"] stringValue];
              }
              if ([errorCode isEqualToString:@"401"] || [errorCode isEqualToString:@"504"]) {
                 [self loginActionWithMessage:@""];
              } else {
                 NSString *errorDisplay = [[NSString alloc] initWithFormat:BALocalizedString(@"Ein interner Fehler ist aufgetreten. Sollte dieser Fehler wiederholt auftreten, kontaktieren Sie bitte Ihre Bibliothek unter Angabe der folgenden Fehlernummer:\nPAIA %@"), errorCode];
                 
                 UIAlertController * alertError = [UIAlertController
                                   alertControllerWithTitle:nil
                                                    message:errorDisplay
                                             preferredStyle:UIAlertControllerStyleAlert];

                 UIAlertAction* okAction = [UIAlertAction
                                           actionWithTitle:BALocalizedString(@"Ok")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                   }];

                 [alertError addAction:okAction];
                 [self presentViewController:alertError animated:YES completion:nil];
              }
           } else {
              self.isLoggingIn = NO;
              [self setCurrentPassword:nil];
              [self loginActionWithMessage:BALocalizedString(@"Bitte Nummer und Passwort prüfen")];
           }
        }
        else if ([command isEqualToString:@"login"]) {
            self.isLoggingIn = NO;
            if ([json objectForKey:@"error"] || json == nil) {
                [self.appDelegate setCurrentPassword:nil];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:BALocalizedString(@"Bei der Anmeldung ist ein Fehler aufgetreten")
                                                                message:[[NSString alloc] initWithFormat:@"%@ - %@", [json objectForKey:@"code"], [json objectForKey:@"error"]]
                                                               delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
                [alert setTag:1];
                [alert show];
            } else {
                [self.appDelegate setIsLoggedIn:YES];
                [self setCurrentToken:[json objectForKey:@"access_token"]];
                [self.appDelegate setCurrentAccount:self.currentAccount];
                [self.appDelegate setCurrentPassword:self.currentPassword];
                [self.appDelegate setCurrentToken:self.currentToken];
                [self setCurrentScope:[[json objectForKey:@"scope"] componentsSeparatedByString:@" "]];
                [self.appDelegate setCurrentScope: self.currentScope];
                
                //UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                //[spinner startAnimating];
                //spinner.frame = CGRectMake(0, 0, 320, 44);
                //self.accountTableView.tableHeaderView = spinner;
                [self.refreshControl beginRefreshing];
                [self.accountTableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:NO];
                BAConnector *accountPatronConnector = [BAConnector generateConnector];
                [accountPatronConnector accountLoadPatronWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
                BAConnector *accountLoanConnector = [BAConnector generateConnector];
                [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
                BAConnector *accountFeesConnector = [BAConnector generateConnector];
                [accountFeesConnector accountLoadFeesWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
                }
        } else if ([command isEqualToString:@"accountLoadLoanList"]) {
            [self.loan removeAllObjects];
            [self.reservation removeAllObjects];
            for (NSDictionary *document in [json objectForKey:@"doc"]) {
                BAEntryWork *tempEntryWork = [[BAEntryWork alloc] init];
                [tempEntryWork setTitle:[document objectForKey:@"about"]];
                [tempEntryWork setItem:[document objectForKey:@"item"]];
                [tempEntryWork setEdition:[document objectForKey:@"edition"]];
                [tempEntryWork setBar:[document objectForKey:@"barcode"]];
                [tempEntryWork setLabel:[document objectForKey:@"label"]];
                [tempEntryWork setQueue:[document objectForKey:@"queue"]];
                [tempEntryWork setRenewal:[document objectForKey:@"renewals"]];
                [tempEntryWork setStorage:[document objectForKey:@"storage"]];
                [tempEntryWork setStatus:[document objectForKey:@"status"]];
               
                NSArray *matchesDayFirst;
                NSArray *matchesYearFirst;
                if ([document objectForKey:@"duedate"] != nil) {
                   NSRegularExpression* regexDayFirst = [NSRegularExpression regularExpressionWithPattern:@"\\d\\d-\\d\\d-\\d\\d\\d\\d" options:0 error:&error];
                   matchesDayFirst = [regexDayFirst matchesInString:[document objectForKey:@"duedate"] options:0 range:NSMakeRange(0, [[document objectForKey:@"duedate"] length])];
                   NSRegularExpression* regexYearFirst = [NSRegularExpression regularExpressionWithPattern:@"\\d\\d\\d\\d-\\d\\d-\\d\\d" options:0 error:&error];
                   matchesYearFirst = [regexYearFirst matchesInString:[document objectForKey:@"duedate"] options:0 range:NSMakeRange(0, [[document objectForKey:@"duedate"] length])];
                }
                if([matchesDayFirst count] > 0){
                   [tempEntryWork setDuedate:[[document objectForKey:@"duedate"] stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
                   if ([self.appDelegate.configuration usePAIAWrapper]) {
                      [tempEntryWork setStarttime:[[document objectForKey:@"duedate"] stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
                      [tempEntryWork setEndtime:[[document objectForKey:@"duedate"] stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
                   }
                } else if ([matchesYearFirst count] > 0){
                   NSString *year = [[document objectForKey:@"duedate"] substringWithRange: NSMakeRange (0, 4)];
                   NSString *month = [[document objectForKey:@"duedate"] substringWithRange: NSMakeRange (5, 2)];
                   NSString *day = [[document objectForKey:@"duedate"] substringWithRange: NSMakeRange (8, 2)];
                   [tempEntryWork setDuedate:[[NSString alloc] initWithFormat:@"%@.%@.%@", day, month, year]];
                   if ([self.appDelegate.configuration usePAIAWrapper]) {
                      [tempEntryWork setStarttime:[[NSString alloc] initWithFormat:@"%@.%@.%@", day, month, year]];
                      [tempEntryWork setEndtime:[[NSString alloc] initWithFormat:@"%@.%@.%@", day, month, year]];
                   }
                }
               
                if (![self.appDelegate.configuration usePAIAWrapper]) {
                   NSString *yearStarttime = [[document objectForKey:@"starttime"] substringWithRange: NSMakeRange (0, 4)];
                   NSString *monthStarttime = [[document objectForKey:@"starttime"] substringWithRange: NSMakeRange (5, 2)];
                   NSString *dayStarttime = [[document objectForKey:@"starttime"] substringWithRange: NSMakeRange (8, 2)];
                   [tempEntryWork setStarttime:[[NSString alloc] initWithFormat:@"%@.%@.%@", dayStarttime, monthStarttime, yearStarttime]];
               
                   NSString *yearEndtime = [[document objectForKey:@"endtime"] substringWithRange: NSMakeRange (0, 4)];
                   NSString *monthEndtime = [[document objectForKey:@"endtime"] substringWithRange: NSMakeRange (5, 2)];
                   NSString *dayEndtime = [[document objectForKey:@"endtime"] substringWithRange: NSMakeRange (8, 2)];
                   if (dayEndtime != nil && monthEndtime != nil && yearEndtime != nil) {
                      [tempEntryWork setEndtime:[[NSString alloc] initWithFormat:@"%@.%@.%@", dayEndtime, monthEndtime, yearEndtime]];
                   } else {
                      [tempEntryWork setEndtime:[[NSString alloc] initWithFormat:@""]];
                   }
                }
                   
               if ([[document objectForKey:@"status"] integerValue] == 2 || [[document objectForKey:@"status"] integerValue] == 3 || [[document objectForKey:@"status"] integerValue] == 4) {
                  [self.loan addObject:tempEntryWork];
                  if (([[document objectForKey:@"canrenew"] integerValue] == 1) || ([document objectForKey:@"canrenew"] == nil)) {
                     [tempEntryWork setCanRenewCancel:YES];
                  } else {
                     [tempEntryWork setCanRenewCancel:NO];
                  }
               } else if ([[document objectForKey:@"status"] integerValue] == 1) {
                  [self.reservation addObject:tempEntryWork];
                  if ([self.appDelegate.configuration usePAIAWrapper]) {
                     if ([[document objectForKey:@"canrenew"] integerValue] == 1 || [[document objectForKey:@"cancancel"] integerValue] == 1) {
                        [tempEntryWork setCanRenewCancel:YES];
                     } else {
                        [tempEntryWork setCanRenewCancel:NO];
                     }
                  } else {
                     if ([[document objectForKey:@"cancancel"] integerValue] == 1) {
                        [tempEntryWork setCanRenewCancel:YES];
                     } else {
                        [tempEntryWork setCanRenewCancel:NO];
                     }
                  }
               }
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd.MM.yyyy"];

            NSArray *sortedLoan = [self.loan sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *first =  [dateFormatter dateFromString:[(BAEntryWork*)a endtime]];
                NSDate *second = [dateFormatter dateFromString:[(BAEntryWork*)b endtime]];
                return [first compare:second];
            }];
            self.loan = [sortedLoan mutableCopy];
            
            NSArray *sortedReservation = [self.reservation sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *first =  [dateFormatter dateFromString:[(BAEntryWork*)a endtime]];
                NSDate *second = [dateFormatter dateFromString:[(BAEntryWork*)b endtime]];
                return [first compare:second];
            }];
            self.reservation = [sortedReservation mutableCopy];
            
            [self.accountTableView reloadData];
            self.accountTableView.tableHeaderView = nil;
            if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
                if ([self.loan count] == 0) {
                    UITextView *header = [[UITextView alloc] init];
                    [header setText:BALocalizedString(@"Keine Medien entliehen")];
                    [header setFrame:CGRectMake(0, 0, 320, 30)];
                    [header setTextAlignment:NSTextAlignmentCenter];
                    self.accountTableView.tableHeaderView = header;
                }
            } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
                if ([self.reservation count] == 0) {
                    UITextView *header = [[UITextView alloc] init];
                    [header setText:BALocalizedString(@"Keine Vormerkungen")];
                    [header setFrame:CGRectMake(0, 0, 320, 30)];
                    [header setTextAlignment:NSTextAlignmentCenter];
                    self.accountTableView.tableHeaderView = header;
                }
            }
           [self.refreshControl endRefreshing];
        } else if ([command isEqualToString:@"accountLoadReservedList"]) {
        } else if ([command isEqualToString:@"accountLoadFees"]) {
            [self.feesSum removeAllObjects];
            [self.fees removeAllObjects];
            NSString *tempAmountString = [json objectForKey:@"amount"];
            if (![tempAmountString isEqualToString:@""]) {
                BAFee *tempAmount = [[BAFee alloc] init];
                [tempAmount setAmount:tempAmountString];
                [tempAmount setSum:YES];
                [self.feesSum addObject:tempAmount];
            }
            for (NSDictionary *fee in [json objectForKey:@"fee"]) {
                BAFee *tempAmount = [[BAFee alloc] init];
                [tempAmount setAbout:[fee objectForKey:@"about"]];
                [tempAmount setAmount:[fee objectForKey:@"amount"]];
                [tempAmount setDate:[fee objectForKey:@"date"]];
                [tempAmount setEdition:[fee objectForKey:@"edition"]];
                [tempAmount setItem:[fee objectForKey:@"item"]];
                [tempAmount setSum:NO];
                [self.fees addObject:tempAmount];
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
            
            NSArray *sortedFees = [self.fees sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSDate *first =  [dateFormatter dateFromString:[(BAFee*)a date]];
                NSDate *second = [dateFormatter dateFromString:[(BAFee*)b date]];
                return [first compare:second];
            }];
            self.fees = [sortedFees mutableCopy];
            
            [self.accountTableView reloadData];
            if ([self.accountSegmentedController selectedSegmentIndex] == 2) {
                if ([self.fees count] == 0) {
                    UITextView *header = [[UITextView alloc] init];
                    [header setText:BALocalizedString(@"Keine Gebühren")];
                    [header setFrame:CGRectMake(0, 0, 320, 30)];
                    [header setTextAlignment:NSTextAlignmentCenter];
                    self.accountTableView.tableHeaderView = header;
                }
            }
           [self.refreshControl endRefreshing];
        } else if ([command isEqualToString:@"accountLoadInterloanList"]) {
        } else if ([command isEqualToString:@"accountRenewDocs"]) {
            BAConnector *accountLoanConnector = [BAConnector generateConnector];
            [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
            if ([self.appDelegate.configuration usePAIAWrapper]) {
               [self setSuccessfulEntriesWrapper:[json mutableCopy]];
            } else {
               [self setSuccessfulEntries:[json mutableCopy]];
            }
            [self showRenewCancelDialog];
        } else if ([command isEqualToString:@"accountCancelDocs"]) {
            BAConnector *accountLoanConnector = [BAConnector generateConnector];
            [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
            if ([self.appDelegate.configuration usePAIAWrapper]) {
               [self setSuccessfulEntriesWrapper:[json mutableCopy]];
            } else {
               [self setSuccessfulEntries:[json mutableCopy]];
            }
            [self showRenewCancelDialog];
        } else if ([command isEqualToString:@"accountLoadPatron"]) {
            NSMutableString *displayName = [self.appDelegate.currentAccount mutableCopy];
            if ([[json objectForKey:@"status"] integerValue] == 3) {
               displayName = [[NSMutableString alloc] initWithString:BALocalizedString(@"gesperrt")];
            } else {
               BOOL writeItemsScope = NO;
               for (NSString *tempScope in self.currentScope) {
                  if ([tempScope isEqualToString:@"write_items"]) {
                     writeItemsScope = YES;
                  }
               }
               if (!writeItemsScope) {
                  displayName = [[NSMutableString alloc] initWithString:BALocalizedString(@"gesperrt")];
               }
            }
            [self.navigationController.navigationBar.topItem setTitle:displayName];
            
            self.patron = json;
            self.idButton.enabled = YES;
        }
    } else {
        if ([command isEqualToString:@"accountLoadLoanList"]) {
            [self.loan removeAllObjects];
            [self.reservation removeAllObjects];
            [self.accountTableView reloadData];
            if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
                // Refactor: Reuse header-object when switching tabs.
                UITextView *header = [[UITextView alloc] init];
                [header setText:BALocalizedString(@"Keine Medien entliehen")];
                [header setFrame:CGRectMake(0, 0, 320, 30)];
                [header setTextAlignment:NSTextAlignmentCenter];
                self.accountTableView.tableHeaderView = header;
            } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
                UITextView *header = [[UITextView alloc] init];
                [header setText:BALocalizedString(@"Keine Vormerkungen")];
                [header setFrame:CGRectMake(0, 0, 320, 30)];
                [header setTextAlignment:NSTextAlignmentCenter];
                self.accountTableView.tableHeaderView = header;
            }
            [self.refreshControl endRefreshing];
        } else if ([command isEqualToString:@"accountLoadFees"]) {
            [self.feesSum removeAllObjects];
            [self.fees removeAllObjects];
            [self.accountTableView reloadData];
            if ([self.accountSegmentedController selectedSegmentIndex] == 2) {
                UITextView *header = [[UITextView alloc] init];
                [header setText:BALocalizedString(@"Keine Gebühren")];
                [header setFrame:CGRectMake(0, 0, 320, 30)];
                [header setTextAlignment:NSTextAlignmentCenter];
                self.accountTableView.tableHeaderView = header;
            }
            [self.refreshControl endRefreshing];
        } else if ([command isEqualToString:@"accountRenewDocs"]) {
            self.accountTableView.tableHeaderView = nil;
            BAConnector *accountLoanConnector = [BAConnector generateConnector];
            [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
            [self showRenewCancelDialog];
        } else if ([command isEqualToString:@"accountCancelDocs"]) {
            self.accountTableView.tableHeaderView = nil;
            BAConnector *accountLoanConnector = [BAConnector generateConnector];
            [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
            [self showRenewCancelDialog];
        } else if ([command isEqualToString:@"accountLoadReservedList"]) {
            BAAccountTableHeaderTextView *header;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAAccountTableHeaderTextView" owner:self options:nil];
            header = [nib objectAtIndex:0];
            [self.accountTableView setTableHeaderView:header];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentAction:(id)sender
{
    [self.sendEntries removeAllObjects];
    [self.successfulEntries removeAllObjects];
   
    BAConnector *checkNetworkReachabilityConnector = [BAConnector generateConnector];
    if ([checkNetworkReachabilityConnector checkNetworkReachability]) {
       if (!self.appDelegate.isLoggedIn) {
              [self loginActionWithMessage:@""];
       } else {
          [self.accountTableView setEditing:NO animated:NO];
          [self.accountTableView reloadData];
          if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
             [self.actionButton setEnabled:YES];
             [self.refreshControl beginRefreshing];
             [self.accountTableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:NO];
             BAConnector *accountLoanConnector = [BAConnector generateConnector];
             [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
          } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
             [self.refreshControl beginRefreshing];
             [self.accountTableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:NO];
             BAConnector *accountLoanConnector = [BAConnector generateConnector];
             [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
             [self.actionButton setEnabled:YES];
          } else if ([self.accountSegmentedController selectedSegmentIndex] == 2) {
             self.accountTableView.tableHeaderView = nil;
             BAConnector *accountFeesConnector = [BAConnector generateConnector];
             [accountFeesConnector accountLoadFeesWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
             [self.actionButton setEnabled:NO];
          } else if ([self.accountSegmentedController selectedSegmentIndex] == 3) {
             [self.actionButton setEnabled:NO];
          } else {
             [self.actionButton setEnabled:NO];
          }
       }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([self.accountSegmentedController selectedSegmentIndex] == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
        return [self.loan count];
    } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
        return [self.reservation count];
    } else if ([self.accountSegmentedController selectedSegmentIndex] == 2) {
        if (section == 0) {
            return [self.feesSum count];
        } else {
            return [self.fees count];
        }
    } else if ([self.accountSegmentedController selectedSegmentIndex] == 3) {
        return [self.interloan count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.accountSegmentedController selectedSegmentIndex] != 2) {
        BAItemAccountCell *cell;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAItemAccountCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        // Configure the cell...
        BAEntryWork *item;
        if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
            item = [self.loan objectAtIndex:indexPath.row];
        } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
            item = [self.reservation objectAtIndex:indexPath.row];
        } else if ([self.accountSegmentedController selectedSegmentIndex] == 3) {
            item = [self.interloan objectAtIndex:indexPath.row];
        } else {
            item = nil;
        }
        
        UIColor *textColor = [UIColor darkTextColor];
        BOOL isOverdue = NO;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"dd.MM.yyyy"];
        NSDate *date = [dateFormat dateFromString:item.endtime];
        NSDate *now = [NSDate date];
        if ([now compare:date] == NSOrderedDescending) {
            textColor = [UIColor redColor];
            isOverdue = YES;
        }
        
        [cell.titleLabel setText:item.title];
        
        [cell.labelTitleLabel setText:BALocalizedString(@"Signatur:")];
        [cell.labelLabel setText:item.label];
        
        if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
            [cell.dateTitleLabel setTextColor:textColor];
            [cell.dateTitleLabel setText:BALocalizedString(@"Leihfristende:")];
            [cell.dateLabel setTextColor:textColor];
            [cell.dateLabel setText:item.endtime];
            [cell.warningLabel setTextColor:textColor];
            [cell.warningLabel setFont:[UIFont fontWithName:@"belugino" size:22]];
            if (isOverdue) {
                [cell.warningLabel setText:@"\uE915"];
            }
        } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
            [cell.dateTitleLabel setText:BALocalizedString(@"Vormerkdatum:")];
            [cell.dateLabel setText:item.starttime];
        }
       
        if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
            [cell.queueTitleLabel setText:BALocalizedString(@"Vormerkungen:")];
            NSString *queueString = [NSString stringWithFormat:@"%@", item.queue];
            [cell.queueLabel setText:queueString];
            [cell.renewalTitleLabel setText:BALocalizedString(@"Verlängerungen:")];
            NSString *renewalString = [NSString stringWithFormat:@"%@", item.renewal];
            [cell.renewalLabel setText:renewalString];
            //NSString *storageString = [NSString stringWithFormat:@"%@", item.storage];
            //[cell.storageLabel setText:storageString];
            [cell.storageLabel setText:[item statusDisplay]];
            if (self.appDelegate.isIOS7) {
               [cell.checkbox setFrame:CGRectMake(287, 64, 23, 23)];
            } else {
               [cell.checkbox setFrame:CGRectMake(293, 63, 23, 23)];
            }
        } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
            [cell.queueTitleLabel setText:@""];
            [cell.queueTitleLabel setHidden:YES];
            [cell.queueLabel setText:@""];
            [cell.queueLabel setHidden:YES];
            [cell.renewalTitleLabel setText:@""];
            [cell.renewalTitleLabel setHidden:YES];
            [cell.renewalLabel setText:@""];
            [cell.renewalLabel setHidden:YES];
            [cell.storageTitleLabel setText:@""];
            [cell.storageTitleLabel setHidden:YES];
            [cell.storageLabel setText:@""];
            [cell.storageLabel setHidden:YES];
            if (self.appDelegate.isIOS7) {
               [cell.checkbox setFrame:CGRectMake(287, 38, 23, 23)];
            } else {
               [cell.checkbox setFrame:CGRectMake(293, 37, 23, 23)];
            }
        }
        
        if ([item.matstring isEqualToString:@"book"]) {
            [cell.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"book.png"]]];
        } else if ([item.matstring isEqualToString:@"document"]) {
            [cell.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"document.png"]]];
        } else if ([item.matstring isEqualToString:@"electronic"]) {
            [cell.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"electronic.png"]]];
        }
        
        if (!item.canRenewCancel) {
            [cell.checkbox setHidden:YES];
        }
        
        if (item.selected) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
        return cell;
    } else {
        BAFeeCell *cell;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAFeeCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        // Configure the cell...
        BAFee *fee;
        if (indexPath.section == 0) {
            fee = [self.feesSum objectAtIndex:indexPath.row];
        } else {
            fee = [self.fees objectAtIndex:indexPath.row];
        }
        
        [cell.amount setText:fee.amount];
        [cell.about setText:fee.about];

        if(fee.date != nil){
            NSRegularExpression* regexDayFirst = [NSRegularExpression regularExpressionWithPattern:@"\\d\\d-\\d\\d-\\d\\d\\d\\d" options:0 error:nil];
            NSArray* matchesDayFirst = [regexDayFirst matchesInString:fee.date options:0 range:NSMakeRange(0, [fee.date length])];
            NSRegularExpression* regexYearFirst = [NSRegularExpression regularExpressionWithPattern:@"\\d\\d\\d\\d-\\d\\d-\\d\\d" options:0 error:nil];
            NSArray* matchesYearFirst = [regexYearFirst matchesInString:fee.date options:0 range:NSMakeRange(0, [fee.date length])];
            if([matchesDayFirst count] > 0){
                [cell.date setText:[fee.date stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
            } else if ([matchesYearFirst count] > 0){
                NSString *year = [fee.date substringWithRange: NSMakeRange (0, 4)];
                NSString *month = [fee.date substringWithRange: NSMakeRange (5, 2)];
                NSString *day = [fee.date substringWithRange: NSMakeRange (8, 2)];
                [cell.date setText:[[NSString alloc] initWithFormat:@"%@.%@.%@", day, month, year]];
            }
        } else {
            [cell.date setText:@""];
        }
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
        return 152.0;
    } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
        return 100.0;
    } else {
        return 81.0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.accountSegmentedController selectedSegmentIndex] == 2) {
        if ([self.fees count] > 0) {
            if (section == 0)
            {
                return BALocalizedString(@"Summe");
            } else {
                return BALocalizedString(@"Einzelposten");
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:NO];
    UITableViewCell *cell = [theTableView cellForRowAtIndexPath:newIndexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
            if ([[self.loan objectAtIndex:newIndexPath.row] canRenewCancel]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[self.loan objectAtIndex:newIndexPath.row] setSelected:YES];
            }
        } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
            if ([[self.reservation objectAtIndex:newIndexPath.row] canRenewCancel]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[self.reservation objectAtIndex:newIndexPath.row] setSelected:YES];
            }
        }
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
            [[self.loan objectAtIndex:newIndexPath.row] setSelected:NO];
        } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
            [[self.reservation objectAtIndex:newIndexPath.row] setSelected:NO];
        }
    }
}

- (void)loginActionWithMessage:(NSString*) message
{
    self.accountTableView.tableHeaderView = nil;
    if (self.appDelegate.account.account != nil && appDelegate.account.password != nil) {
        [self setCurrentAccount:self.appDelegate.account.account];
        BAConnector *accountConnector = [BAConnector generateConnector];
        [accountConnector loginWithAccount:appDelegate.account.account WithPassword:appDelegate.account.password WithDelegate:self];
    } else if (self.currentAccount != nil && self.currentPassword != nil) {
        BAConnector *accountConnector = [BAConnector generateConnector];
        [accountConnector loginWithAccount:self.currentAccount WithPassword:self.currentPassword WithDelegate:self];
    } else {
        if (!self.isLoggingIn) {
            self.isLoggingIn = YES;
           
            NSMutableString *displayString = [message mutableCopy];
            if (message != nil) {
               if (![message isEqualToString:@""]) {
                  [displayString appendString:@"\n\n"];
               }
            }
            [displayString appendString:BALocalizedString(@"Unter Optionen können Sie das Speichern der Login-Daten aktivieren.\nDort können Sie ebenfalls die aktuelle Sitzung beenden.")];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:BALocalizedString(@"Anmeldung")
                                                            message:displayString
                                                           delegate:self cancelButtonTitle:BALocalizedString(@"Abbrechen") otherButtonTitles:BALocalizedString(@"Anmelden"), nil];
            [alert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
            [alert setTag:0];
            if (self.currentAccount != nil) {
                [[alert textFieldAtIndex:0] setText:self.currentAccount];
            }
            [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            [[alert textFieldAtIndex:0] setPlaceholder:BALocalizedString(@"Benutzernummer")];
            [[alert textFieldAtIndex:1] setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
            
            [alert show];
        }
    }
}

- (IBAction)actionButtonAction:(id)sender
{
    if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
        BOOL foundSelected = NO;
        for (BAEntryWork *tempEmtry in self.loan) {
            if (tempEmtry.selected) {
                foundSelected = YES;
            }
        }
        if (foundSelected) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:BALocalizedString(@"Abbrechen")
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:BALocalizedString(@"Verlängern"), nil];
        
            // Show the sheet
            [action setTag:10];
            [action showInView:self.parentViewController.parentViewController.view];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:BALocalizedString(@"Bitte wählen Sie die Einträge aus, die verlängert werden sollen")
                                                           delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
            [alert setTag:21];
            [alert show];
        }
    } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
        BOOL foundSelected = NO;
        for (BAEntryWork *tempEmtry in self.reservation) {
            if (tempEmtry.selected) {
                foundSelected = YES;
            }
        }
        if (foundSelected) {
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:BALocalizedString(@"Abbrechen")
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:BALocalizedString(@"Vormerkungen stornieren"), nil];
        
            // Show the sheet
            [action setTag:11];
            [action showInView:self.parentViewController.parentViewController.view];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:BALocalizedString(@"Bitte wählen Sie die Vormerkungen aus, die storniert werden sollen")
                                                           delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
            [alert setTag:22];
            [alert show];
        }
    }
}

- (IBAction)idButtonAction:(id)sender {
    [self performSegueWithIdentifier:@"idSegue" sender:self];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.accountTableView setContentOffset:CGPointZero animated:NO];
    if (actionSheet.tag == 10) {
        if (buttonIndex == 0) {
            [self setSendEntries:[[NSMutableArray alloc] init]];
            [self setSuccessfulEntriesWrapper:[[NSMutableArray alloc] init]];
            [self setSuccessfulEntries:[[NSMutableDictionary alloc] init]];
            for (BAEntryWork *tempEmtry in self.loan) {
                if (tempEmtry.selected) {
                    [self.sendEntries addObject:tempEmtry];
                }
            }
            //UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            //[spinner startAnimating];
            //spinner.frame = CGRectMake(0, 0, 320, 44);
            //self.accountTableView.tableHeaderView = spinner;
            [self.refreshControl beginRefreshing];
            [self.accountTableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:NO];
            BAConnector *renewConnector = [BAConnector generateConnector];
            [renewConnector accountRenewDocs:self.sendEntries WithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
        }
    } else if (actionSheet.tag == 11) {
        if (buttonIndex == 0) {
            [self setSendEntries:[[NSMutableArray alloc] init]];
            [self setSuccessfulEntriesWrapper:[[NSMutableArray alloc] init]];
            [self setSuccessfulEntries:[[NSMutableDictionary alloc] init]];
            for (BAEntryWork *tempEmtry in self.reservation) {
                if (tempEmtry.selected) {
                    [self.sendEntries addObject:tempEmtry];
                }
            }
            //UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            //[spinner startAnimating];
            //spinner.frame = CGRectMake(0, 0, 320, 44);
            //self.accountTableView.tableHeaderView = spinner;
            [self.refreshControl beginRefreshing];
            [self.accountTableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:NO];
            BAConnector *cancelConnector = [BAConnector generateConnector];
            [cancelConnector accountCancelDocs:self.sendEntries WithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
        }
    }
}

- (void)showRenewCancelDialog
{
    NSMutableString *statusString = [[NSMutableString alloc] initWithString:@""];
   
    int renewalsCounter = 0;
    if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
       for (BAEntryWork *tempSendEntry in self.sendEntries) {
          if ([self.appDelegate.configuration usePAIAWrapper]) {
             for (int i = 0; i < [self.successfulEntriesWrapper count]; i++) {
                NSDictionary *tempSuccessfulEntry = [self.successfulEntriesWrapper objectAtIndex:i];
                if ([tempSendEntry.item isEqualToString:[tempSuccessfulEntry objectForKey:@"itemURI"]]) {
                   if ([tempSendEntry.renewal integerValue] < [[tempSuccessfulEntry objectForKey:@"renewals"] integerValue]) {
                      renewalsCounter++;
                   }
                }
             }
          } else {
             for (NSDictionary *tempSuccessfulEntry in [self.successfulEntries objectForKey:@"doc"]) {
                if ([tempSendEntry.item isEqualToString:[tempSuccessfulEntry objectForKey:@"item"]]) {
                   if ([tempSendEntry.renewal integerValue] < [[tempSuccessfulEntry objectForKey:@"renewals"] integerValue]) {
                      renewalsCounter++;
                   }
                }
             }
          }
       }
       if (renewalsCounter > 0) {
          [statusString appendFormat:BALocalizedString(@"%d von %lu Titel(n) verlängert.\n\n"), renewalsCounter, (unsigned long)[self.sendEntries count]];
       } else {
          [statusString appendString:BALocalizedString(@"Es konnte kein Titel verlängert werden\n\n")];
       }
       if ([self.appDelegate.configuration usePAIAWrapper]) {
          for (int i = 0; i < [self.successfulEntriesWrapper count]; i++) {
             NSDictionary *tempSuccessfulEntry = [self.successfulEntriesWrapper objectAtIndex:i];
             if ([tempSuccessfulEntry objectForKey:@"error"] != nil) {
                //if ([tempSuccessfulEntry objectForKey:@"item"] != nil) {
                //   [statusString appendFormat:@"%@:\n", [tempSuccessfulEntry objectForKey:@"item"]];
                //}
                [statusString appendFormat:@"%@\n\n", [tempSuccessfulEntry objectForKey:@"error"]];
             }
          }
       } else {
          for (NSDictionary *tempSuccessfulEntry in [self.successfulEntries objectForKey:@"doc"]) {
             if ([tempSuccessfulEntry objectForKey:@"error"] != nil) {
                //if ([tempSuccessfulEntry objectForKey:@"item"] != nil) {
                //   [statusString appendFormat:@"%@:\n", [tempSuccessfulEntry objectForKey:@"item"]];
                //}
                [statusString appendFormat:@"%@\n\n", [tempSuccessfulEntry objectForKey:@"error"]];
             }
          }
       }
    } else if ([self.accountSegmentedController selectedSegmentIndex] == 1) {
       NSMutableString *requestString = [[NSMutableString alloc] init];
       if ([self.appDelegate.configuration usePAIAWrapper]) {
          if ([self.successfulEntriesWrapper count] > 1) {
             [requestString appendString:BALocalizedString(@"Vormerkungen")];
          } else {
             [requestString appendString:BALocalizedString(@"Vormerkung")];
          }
       } else {
          if ([[self.successfulEntries objectForKey:@"doc"] count] > 1) {
             [requestString appendString:BALocalizedString(@"Vormerkungen")];
          } else {
             [requestString appendString:BALocalizedString(@"Vormerkung")];
          }
       }
       if ([self.appDelegate.configuration usePAIAWrapper]) {
          [statusString appendFormat:BALocalizedString(@"%lu %@ storniert.\n\n"), (unsigned long)[self.successfulEntriesWrapper count], requestString];
       } else {
          [statusString appendFormat:BALocalizedString(@"%lu %@ storniert.\n\n"), (unsigned long)[[self.successfulEntries objectForKey:@"doc"] count], requestString];
       }
    }
    
   if ([self.sendEntries count] > 0) {
      if ([self.appDelegate.configuration usePAIAWrapper]) {
         if ([self.sendEntries count] > [self.successfulEntriesWrapper count]) {
            if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
               [statusString appendString:BALocalizedString(@"Die folgenden Titel konnten nicht verlängert werden:\n\n")];
            } else if ([self.accountSegmentedController selectedSegmentIndex] == 1){
               [statusString appendString:BALocalizedString(@"Die folgenden Vormerkungen konnten nicht storniert werden:\n\n")];
            }
            for (BAEntryWork *tempSendEntry in self.sendEntries) {
               BOOL wasSuccessful = NO;
               for (NSDictionary *tempSuccessfulEntry in self.successfulEntriesWrapper) {
                  if ([tempSendEntry.label isEqualToString:[tempSuccessfulEntry valueForKey:@"signature"]]) {
                     wasSuccessful = YES;
                  }
               }
               if (!wasSuccessful) {
                  [statusString appendString:[[NSString alloc] initWithFormat:@"• %@\n\n", tempSendEntry.title]];
               }
            }
         }
      }
      /* else {
         if ([self.sendEntries count] > [[self.successfulEntries objectForKey:@"doc"] count]) {
            if ([self.accountSegmentedController selectedSegmentIndex] == 0) {
               [statusString appendString:@"Die folgenden Titel konnten nicht verlängert werden:\n\n"];
            } else if ([self.accountSegmentedController selectedSegmentIndex] == 1){
               [statusString appendString:@"Die folgenden Vormerkungen konnten nicht storniert werden:\n\n"];
            }
            for (BAEntryWork *tempSendEntry in self.sendEntries) {
               BOOL wasSuccessful = NO;
               for (NSDictionary *tempSuccessfulEntry in [self.successfulEntries objectForKey:@"doc"]) {
                  if ([tempSendEntry.label isEqualToString:[tempSuccessfulEntry valueForKey:@"signature"]]) {
                     wasSuccessful = YES;
                  }
               }
               if (!wasSuccessful) {
                  [statusString appendString:[[NSString alloc] initWithFormat:@"• %@\n\n", tempSendEntry.title]];
               }
            }
         }
      } */
   }
   
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:statusString
                                                   delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
    [alert setTag:20];
    [alert show];
}

- (void)didPresentAlertView:(UIAlertView *)alertView
{
    if (alertView.tag == 0) {
        if (self.currentAccount != nil) {
            if (![self.currentAccount isEqualToString:@""]) {
                [[alertView textFieldAtIndex:1] becomeFirstResponder];
            }
        }
    }
}

- (void)commandIsNotInScope:(NSString *)command {
   if ([command isEqualToString:@"accountRenewDocs"]) {
      BAConnector *accountLoanConnector = [BAConnector generateConnector];
      [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
   } else if ([command isEqualToString:@"accountCancelDocs"]) {
      BAConnector *accountLoanConnector = [BAConnector generateConnector];
      [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
   }
}

- (void)refreshLoanAndReservation:(UIRefreshControl *)refreshControl {
   BAConnector *accountLoanConnector = [BAConnector generateConnector];
   [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
}

- (void)viewDidLayoutSubviews
{
   [self.refreshControl.superview sendSubviewToBack:self.refreshControl];
}

- (void)networkIsNotReachable:(NSString *)command {
   [self commandIsNotInScope:command];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"idSegue"]) {
        BAIdViewController *idController = (BAIdViewController *)[segue destinationViewController];
        idController.account = self.currentAccount;
        idController.patron = self.patron;
    }
}

@end
