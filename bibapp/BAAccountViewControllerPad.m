//
//  BAAccountViewControllerPad.m
//  bibapp
//
//  Created by Johannes Schultze on 20.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAAccountViewControllerPad.h"
#import "BAConnector.h"
#import "BAEntryWork.h"
#import "BAFee.h"
#import "BAAccountTableHeaderTextView.h"
#import "BAItemAccountCell.h"
#import "BAFeeCell.h"
#import "BAOptionsNavigationController.h"
#import "BALocalizeHelper.h"

@interface BAAccountViewControllerPad ()

@end

@implementation BAAccountViewControllerPad

@synthesize loanTableView;
@synthesize reservationTableView;
@synthesize feeTableView;
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
@synthesize loanHeader;
@synthesize reservationHeader;
@synthesize feeHeader;
@synthesize statusBarTintUIView;
@synthesize loanRefreshControl;
@synthesize reservationRefreshControl;
@synthesize feeRefreshControl;
@synthesize loanLoadingLabel;
@synthesize reservationLoadingLabel;
@synthesize feeLoadingLabel;

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
    
    [self.accountNavigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    [self.loanToolbar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    [self.reservationToolbar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    [self.feeToolbar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    if (self.appDelegate.isIOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
        //[self.statusBarTintUIView setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.accountNavigationBar setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.loanToolbar setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.reservationToolbar setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.feeToolbar setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.loanBarButton setTintColor:[UIColor whiteColor]];
        //[self.reservationBarButton setTintColor:[UIColor whiteColor]];
        //[self.optionsButton setTintColor:[UIColor whiteColor]];
    } else {
        [self.statusBarTintUIView setHidden:YES];
    }
    
    self.loan = [[NSMutableArray alloc] init];
    self.reservation = [[NSMutableArray alloc] init];
    self.interloan = [[NSMutableArray alloc] init];
    self.feesSum = [[NSMutableArray alloc] init];
    self.fees = [[NSMutableArray alloc] init];
    
    [self.loanTableView setTag:0];
    [self.loanBarButton setEnabled:NO];
    [self.loanBarButton setTag:10];
    [self.loanBarButton setTarget:self];
    [self.loanBarButton setAction:@selector(actionButtonClick:)];
    
    NSArray *nibLoan = [[NSBundle mainBundle] loadNibNamed:@"BAAccountTableHeaderViewPad" owner:self options:nil];
    self.loanHeader = [nibLoan objectAtIndex:0];
    [self.loanHeader.subTitleLabel setText:@""];
    self.loanTableView.tableHeaderView = self.loanHeader;
    
    [self.reservationTableView setTag:1];
    [self.reservationBarButton setEnabled:NO];
    [self.reservationBarButton setTag:11];
    [self.reservationBarButton setTarget:self];
    [self.reservationBarButton setAction:@selector(actionButtonClick:)];
    
    NSArray *nibReservation = [[NSBundle mainBundle] loadNibNamed:@"BAAccountTableHeaderViewPad" owner:self options:nil];
    self.reservationHeader = [nibReservation objectAtIndex:0];
    [self.reservationHeader.subTitleLabel setText:@""];
    self.reservationTableView.tableHeaderView = self.reservationHeader;
    
    [self.feeTableView setTag:2];
    NSArray *nibFee = [[NSBundle mainBundle] loadNibNamed:@"BAAccountTableHeaderViewPad" owner:self options:nil];
    self.feeHeader = [nibFee objectAtIndex:0];
    [self.feeHeader.subTitleLabel setText:@""];
    self.feeTableView.tableHeaderView = self.feeHeader;
   
    [self setLoanRefreshControl:[[UIRefreshControl alloc] init]];
    [self.loanRefreshControl addTarget:self action:@selector(refreshLoanAndReservation:) forControlEvents:UIControlEventValueChanged];
    [self.loanTableView addSubview:self.loanRefreshControl];
   
    [self setReservationRefreshControl:[[UIRefreshControl alloc] init]];
    [self.reservationRefreshControl addTarget:self action:@selector(refreshLoanAndReservation:) forControlEvents:UIControlEventValueChanged];
    [self.reservationTableView addSubview:self.reservationRefreshControl];
   
    [self setFeeRefreshControl:[[UIRefreshControl alloc] init]];
    [self.feeRefreshControl addTarget:self action:@selector(refreshFee:) forControlEvents:UIControlEventValueChanged];
    [self.feeTableView addSubview:self.feeRefreshControl];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    BAConnector *checkNetworkReachabilityConnector = [BAConnector generateConnector];
    if ([checkNetworkReachabilityConnector checkNetworkReachability]) {
       if (!self.appDelegate.isLoggedIn) {
              [self reset];
              [self loginActionWithMessage:@""];
       } else {
           [self setSuccessfulEntriesWrapper:[[NSMutableArray alloc] init]];
           [self.successfulEntriesWrapper removeAllObjects];
           [self setSuccessfulEntries:[[NSMutableDictionary alloc] init]];
           [self.sendEntries removeAllObjects];
           [self.loanLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
           [self.reservationLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
           [self.feeLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
           BAConnector *accountLoanConnector = [BAConnector generateConnector];
           [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
           BAConnector *accountFeesConnector = [BAConnector generateConnector];
           [accountFeesConnector accountLoadFeesWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
       }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setLoanTableView:nil];
    [self setReservationTableView:nil];
    [self setFeeTableView:nil];
    [self setAccountNavigationBar:nil];
    [self setLoanToolbar:nil];
    [self setReservationToolbar:nil];
    [self setFeeToolbar:nil];
    [self setLoanBarButton:nil];
    [self setReservationBarButton:nil];
    [super viewDidUnload];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView.tag == 0) {
        return [self.loan count];
    } else if (tableView.tag == 1) {
        return [self.reservation count];
    } else if (tableView.tag == 2) {
        if (section == 0) {
            return [self.feesSum count];
        } else {
            return [self.fees count];
        }
    } else {
        return 0;
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
                   UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                                message:errorDisplay
                                                               delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
                   [alert setTag:20];
                   [alert show];
                }
            } else {
                self.isLoggingIn = NO;
                [self setCurrentPassword:nil];
                [self loginActionWithMessage:BALocalizedString(@"Bitte Nummer und Passwort prüfen")];
            }
        } else if ([command isEqualToString:@"login"]) {
            self.isLoggingIn = NO;
            if ([json objectForKey:@"error"] || json == nil) {
                [self.appDelegate setCurrentPassword:nil];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:BALocalizedString(@"Bei der Anmeldung ist ein Fehler aufgetreten")
                                                                message:[[NSString alloc] initWithFormat:@"%@ - %@", [json objectForKey:@"code"], [json objectForKey:@"error"]]
                                                               delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
            [dateFormatter setDateFormat:@"dd.mm.yyyy"];
            
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
            
            [self.loanTableView reloadData];
            [self.reservationTableView reloadData];
                if ([self.loan count] == 0) {
                    [self.loanHeader.subTitleLabel setText:BALocalizedString(@"Keine Medien entliehen")];
                    [self.loanBarButton setEnabled:NO];
                } else {
                    [self.loanTableView setTableHeaderView:nil];
                    [self.loanBarButton setEnabled:YES];
                }
                if ([self.reservation count] == 0) {
                    [self.reservationHeader.subTitleLabel setText:BALocalizedString(@"Keine Vormerkungen")];
                    [self.reservationBarButton setEnabled:NO];
                } else {
                    [self.reservationTableView setTableHeaderView:nil];
                    [self.reservationBarButton setEnabled:YES];
                }
           [self.loanRefreshControl endRefreshing];
           [self.reservationRefreshControl endRefreshing];
           [self.loanLoadingLabel performSelectorInBackground:@selector(setText:) withObject:@""];
           [self.reservationLoadingLabel performSelectorInBackground:@selector(setText:) withObject:@""];
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
            
            [self.feeTableView reloadData];
                if ([self.fees count] == 0) {
                    UITextView *header = [[UITextView alloc] init];
                    [header setText:BALocalizedString(@"Keine Gebühren")];
                    [header setFrame:CGRectMake(0, 0, 320, 30)];
                    [header setTextAlignment:NSTextAlignmentCenter];
                    [self.feeHeader.subTitleLabel setText:BALocalizedString(@"Keine Gebühren")];
                } else {
                    [self.feeTableView setTableHeaderView:nil];
                }
           [self.feeRefreshControl endRefreshing];
           [self.feeLoadingLabel performSelectorInBackground:@selector(setText:) withObject:@""];
        } else if ([command isEqualToString:@"accountLoadInterloanList"]) {
        } else if ([command isEqualToString:@"accountRenewDocs"]) {
            BAConnector *accountLoanConnector = [BAConnector generateConnector];
            [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
            if ([self.appDelegate.configuration usePAIAWrapper]) {
               [self setSuccessfulEntriesWrapper:[json mutableCopy]];
            } else {
               [self setSuccessfulEntries:[json mutableCopy]];
            }
            [self showRenewCancelDialogFor:@"renew"];
        } else if ([command isEqualToString:@"accountCancelDocs"]) {
            BAConnector *accountLoanConnector = [BAConnector generateConnector];
            [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
            if ([self.appDelegate.configuration usePAIAWrapper]) {
               [self setSuccessfulEntriesWrapper:[json mutableCopy]];
            } else {
               [self setSuccessfulEntries:[json mutableCopy]];
            }
            [self showRenewCancelDialogFor:@"cancel"];
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
            [self.accountNavigationBar.topItem setTitle:displayName];
        }
    } else {
        if ([command isEqualToString:@"accountLoadLoanList"]) {
            [self.loan removeAllObjects];
            [self.reservation removeAllObjects];
            [self.loanTableView reloadData];
            [self.reservationTableView reloadData];
                UITextView *header = [[UITextView alloc] init];
                [header setText:BALocalizedString(@"Keine Medien entliehen")];
                [header setFrame:CGRectMake(0, 0, 320, 30)];
                [header setTextAlignment:NSTextAlignmentCenter];
                [self.loanHeader.subTitleLabel setText:BALocalizedString(@"Keine Medien entliehen")];
                header = [[UITextView alloc] init];
                [header setText:BALocalizedString(@"Keine Vormerkungen")];
                [header setFrame:CGRectMake(0, 0, 320, 30)];
                [header setTextAlignment:NSTextAlignmentCenter];
                [self.reservationHeader.subTitleLabel setText:BALocalizedString(@"Keine Vormerkungen")];
        } else if ([command isEqualToString:@"accountLoadFees"]) {
            [self.feesSum removeAllObjects];
            [self.fees removeAllObjects];
            [self.feeTableView reloadData];
                UITextView *header = [[UITextView alloc] init];
                [header setText:BALocalizedString(@"Keine Gebühren")];
                [header setFrame:CGRectMake(0, 0, 320, 30)];
                [header setTextAlignment:NSTextAlignmentCenter];
                [self.feeHeader.subTitleLabel setText:BALocalizedString(@"Keine Gebühren")];
        } else if ([command isEqualToString:@"accountRenewDocs"]) {
            [self.loanTableView reloadData];
            BAConnector *accountLoanConnector = [BAConnector generateConnector];
            [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
            [self showRenewCancelDialogFor:@"renew"];
        } else if ([command isEqualToString:@"accountCancelDocs"]) {
            [self.reservationTableView reloadData];
            BAConnector *accountLoanConnector = [BAConnector generateConnector];
            [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
            [self showRenewCancelDialogFor:@"cancel"];
        } else if ([command isEqualToString:@"accountLoadReservedList"]) {
            //BAAccountTableHeaderTextView *header;
            //NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAAccountTableHeaderTextView" owner:self options:nil];
            //header = [nib objectAtIndex:0];
        }
    }
}

- (void)loginActionWithMessage:(NSString*) message
{
    [self.loanHeader.subTitleLabel setText:@""];
    [self.reservationHeader.subTitleLabel setText:@""];
    [self.feeHeader.subTitleLabel setText:@""];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0) {
        if (buttonIndex == 0) {
            self.isLoggingIn = NO;
        } else if(buttonIndex == 1) {
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self.loan count] > 0) {
        [self.loanTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:NO];
        [self.loanTableView setContentOffset:CGPointZero animated:NO];
    }
    if ([self.reservation count] > 0) {
        [self.reservationTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:0 animated:NO];
        [self.reservationTableView setContentOffset:CGPointZero animated:NO];
    }
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
            self.loanTableView.tableHeaderView = self.loanHeader;
            BAConnector *renewConnector = [BAConnector generateConnector];
            [renewConnector accountRenewDocs:self.sendEntries WithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
        }
    } else if(actionSheet.tag == 11) {
        if (buttonIndex == 0) {
            [self setSendEntries:[[NSMutableArray alloc] init]];
            [self setSuccessfulEntriesWrapper:[[NSMutableArray alloc] init]];
            [self setSuccessfulEntries:[[NSMutableDictionary alloc] init]];
            for (BAEntryWork *tempEmtry in self.reservation) {
                if (tempEmtry.selected) {
                    [self.sendEntries addObject:tempEmtry];
                }
            }
            self.reservationTableView.tableHeaderView = self.reservationHeader;
            BAConnector *cancelConnector = [BAConnector generateConnector];
            [cancelConnector accountCancelDocs:self.sendEntries WithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
        }
    }
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

- (void)showRenewCancelDialogFor:(NSString *)action
{
   NSMutableString *statusString = [[NSMutableString alloc] initWithString:@""];
   
   int renewalsCounter = 0;
   if ([action isEqualToString:@"renew"]) {
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
   } else if ([action isEqualToString:@"cancel"]) {
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
             if ([action isEqualToString:@"renew"]) {
                [statusString appendString:BALocalizedString(@"Die folgenden Titel konnten nicht verlängert werden:\n\n")];
             } else if ([action isEqualToString:@"cancel"]){
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
             if ([action isEqualToString:@"renew"]) {
                [statusString appendString:@"Die folgenden Titel konnten nicht verlängert werden:\n\n"];
             } else if ([action isEqualToString:@"cancel"]){
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
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert setTag:20];
    [alert show];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag != 2) {
        BAItemAccountCell *cell;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAItemAccountCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
       
        // Configure the cell...
        BAEntryWork *item;
        if (tableView.tag == 0) {
            item = [self.loan objectAtIndex:indexPath.row];
        } else if (tableView.tag == 1) {
            item = [self.reservation objectAtIndex:indexPath.row];
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
        
        if (tableView.tag == 0) {
           [cell.dateTitleLabel setTextColor:textColor];
           [cell.dateTitleLabel setText:BALocalizedString(@"Leihfristende:")];
           [cell.dateLabel setTextColor:textColor];
           [cell.dateLabel setText:item.endtime];
           [cell.warningLabel setTextColor:textColor];
           [cell.warningLabel setFont:[UIFont fontWithName:@"belugino" size:22]];
           if (isOverdue) {
               [cell.warningLabel setText:@"\uE915"];
           }
        } else if(tableView.tag == 1) {
           [cell.dateTitleLabel setText:BALocalizedString(@"Vormerkdatum:")];
           [cell.dateLabel setText:item.starttime];
        }
       
        if (tableView.tag == 0) {
            NSString *queueString = [NSString stringWithFormat:@"%@", item.queue];
            [cell.queueLabel setText:queueString];
            NSString *renewalString = [NSString stringWithFormat:@"%@", item.renewal];
            [cell.renewalLabel setText:renewalString];
            //NSString *storageString = [NSString stringWithFormat:@"%@", item.storage];
            //[cell.storageLabel setText:storageString];
            [cell.storageLabel setText:[item statusDisplay]];
            if (self.appDelegate.isIOS7) {
               [cell.checkbox setFrame:CGRectMake(307, 64, 23, 23)];
            } else {
               [cell.checkbox setFrame:CGRectMake(313, 63, 23, 23)];
            }
        } else if(tableView.tag == 1) {
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
               [cell.checkbox setFrame:CGRectMake(306, 38, 23, 23)];
            } else {
               [cell.checkbox setFrame:CGRectMake(313, 37, 23, 23)];
            }
        }
       
        if ([item.matstring isEqualToString:@"book"]) {
            [cell.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"book.png"]]];
        } else if([item.matstring isEqualToString:@"document"]) {
            [cell.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"document.png"]]];
        } else if([item.matstring isEqualToString:@"electronic"]) {
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
    if (tableView.tag == 0) {
        return 152.0;
    } else if (tableView.tag == 1) {
        return 100.0;
    } else {
        return 81.0;
    }
}

- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath
{
    [theTableView deselectRowAtIndexPath:[theTableView indexPathForSelectedRow] animated:NO];
    UITableViewCell *cell = [theTableView cellForRowAtIndexPath:newIndexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        if (theTableView.tag == 0) {
            if ([[self.loan objectAtIndex:newIndexPath.row] canRenewCancel]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[self.loan objectAtIndex:newIndexPath.row] setSelected:YES];
            }
        } else if (theTableView.tag == 1) {
            if ([[self.reservation objectAtIndex:newIndexPath.row] canRenewCancel]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[self.reservation objectAtIndex:newIndexPath.row] setSelected:YES];
            }
        }
    } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (theTableView.tag == 0) {
            [[self.loan objectAtIndex:newIndexPath.row] setSelected:NO];
        } else if (theTableView.tag == 1) {
            [[self.reservation objectAtIndex:newIndexPath.row] setSelected:NO];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView.tag == 2) {
        return 2;
    } else {
        return 1;
    }
}

- (void)actionButtonClick:(id)sender
{
    UIButton *clicked = (UIButton *) sender;
    if (clicked.tag == 10) {
        BOOL foundSelected = NO;
        for (BAEntryWork *tempEntry in self.loan) {
            if (tempEntry.selected) {
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
            [action showFromBarButtonItem:self.loanBarButton animated:YES];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:BALocalizedString(@"Bitte wählen Sie die Einträge aus, die verlängert werden sollen")
                                                           delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
            [alert setTag:21];
            [alert show];
        }
    } else if (clicked.tag == 11) {
        BOOL foundSelected = NO;
        for (BAEntryWork *tempEntry in self.reservation) {
            if (tempEntry.selected) {
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
            [action showFromBarButtonItem:self.reservationBarButton animated:YES];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil
                                                            message:BALocalizedString(@"Bitte wählen Sie die Vormerkungen aus, die storniert werden sollen")
                                                           delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
            [alert setTag:22];
            [alert show];
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == 2) {
        if ([self.fees count] > 0) {
            if (section == 0) {
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

- (void)refreshLoanAndReservation:(UIRefreshControl *)refreshControl {
   if (!self.appDelegate.isLoggedIn) {
      [self reset];
      [self loginActionWithMessage:@""];
   } else {
      [self.loanLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
      [self.reservationLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
      BAConnector *accountLoanConnector = [BAConnector generateConnector];
      [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
   }
}

- (void)refreshFee:(UIRefreshControl *)refreshControl {
   if (!self.appDelegate.isLoggedIn) {
      [self reset];
      [self loginActionWithMessage:@""];
   } else {
      [self.feeLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
      BAConnector *accountFeesConnector = [BAConnector generateConnector];
      [accountFeesConnector accountLoadFeesWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
   }
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

- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLayoutSubviews
{
   [self.loanRefreshControl.superview sendSubviewToBack:self.loanRefreshControl];
   [self.reservationRefreshControl.superview sendSubviewToBack:self.reservationRefreshControl];
   [self.feeRefreshControl.superview sendSubviewToBack:self.feeRefreshControl];
}

- (void)commandIsNotInScope:(NSString *)command {
   if ([command isEqualToString:@"accountRenewDocs"]) {
      [self.loanLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
      [self.reservationLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
      BAConnector *accountLoanConnector = [BAConnector generateConnector];
      [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
   } else if ([command isEqualToString:@"accountCancelDocs"]) {
      [self.loanLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
      [self.reservationLoadingLabel performSelectorInBackground:@selector(setText:) withObject:BALocalizedString(@"wird geladen ...")];
      BAConnector *accountLoanConnector = [BAConnector generateConnector];
      [accountLoanConnector accountLoadLoanListWithAccount:self.currentAccount WithToken:self.currentToken WithDelegate:self];
   }
}

- (void)networkIsNotReachable:(NSString *)command {
   [self commandIsNotInScope:command];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([[segue identifier] isEqualToString:@"optionsSegue"]) {
      BAOptionsNavigationController *optionsNavigationController = (BAOptionsNavigationController *)[segue destinationViewController];
      [optionsNavigationController setAccountViewController:self];
   }
}

-(void)reset {
   [self setCurrentAccount:nil];
   [self setCurrentPassword:nil];
   [self setCurrentScope:nil];
   [self setCurrentToken:nil];
   [self.accountNavigationBar.topItem setTitle:BALocalizedString(@"Konto")];
   [self.loanHeader.subTitleLabel setText:@""];
   [self.reservationHeader.subTitleLabel setText:@""];
   [self.feeHeader.subTitleLabel setText:@""];
   [self.loan removeAllObjects];
   [self.reservation removeAllObjects];
   [self.fees removeAllObjects];
   [self.loanTableView reloadData];
   [self.reservationTableView reloadData];
   [self.feeTableView reloadData];
}

@end
