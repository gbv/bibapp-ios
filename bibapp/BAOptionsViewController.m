//
//  BAOptionsViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 04.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAOptionsViewController.h"
#import "BAAppDelegate.h"
#import "BAConnector.h"
#import "BALocalizeHelper.h"

@interface BAOptionsViewController ()

@end

@implementation BAOptionsViewController

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
    
    [self.navigationItem setTitle:BALocalizedString(@"Optionen")];
    
    self.tableView.delegate = self;
    
    [self.navigationController.navigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.options.saveLocalData) {
        [self.saveLocalSwitch setOn:YES];
    }
    if (!appDelegate.options.allowCountPixel) {
        [self.countPixelSwitch setOn:NO];
    }
    
    [self.catalogueLabel setText:self.appDelegate.options.selectedCatalogue];
    [self.languageLabel setText:BALocalizedString(self.appDelegate.options.selectedLanguage)];
    [self.versionLabel setText:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.catalogueTitleLabel setText:BALocalizedString(@"Lokaler Katalog")];
    [self.catalogueLabel setText:BALocalizedString(self.appDelegate.options.selectedCatalogue)];
    [self.languageLabel setText:BALocalizedString(self.appDelegate.options.selectedLanguage)];
    [self.accountTitleLabel setText:BALocalizedString(@"Zugangsdaten speichern")];
    [self.logoutButton setTitle:BALocalizedString(@"Abmelden") forState:UIControlStateNormal];
    [self.privacyTitleLabel setText:BALocalizedString(@"Anonyme Daten speichern")];
    
    if (self.appDelegate.currentAccount != nil) {
       [self.userLabel setText:self.appDelegate.currentAccount];
       [self.logoutButton setEnabled:YES];
    } else {
       [self.userLabel setText:BALocalizedString(@"Nicht angemeldet")];
       [self.logoutButton setEnabled:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)countPixelSwitchAction:(id)sender {
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([sender isOn]) {
        [appDelegate.options setAllowCountPixel:YES];
    } else {
        [appDelegate.options setAllowCountPixel:NO];
    }
    NSError *error = nil;
    if (![[appDelegate managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

- (IBAction)logoutAction:(id)sender {
   BAConnector *logoutConnector = [BAConnector generateConnector];
   [logoutConnector logoutWithAccount:self.appDelegate.currentAccount WithToken:self.appDelegate.currentToken WithDelegate:self];
}

- (IBAction)saveLocalSwithAction:(id)sender
{
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([sender isOn]) {
        [appDelegate.options setSaveLocalData:YES];
        [appDelegate.account setAccount:appDelegate.currentAccount];
        [appDelegate.account setPassword:appDelegate.currentPassword];
    } else {
        [appDelegate.options setSaveLocalData:NO];
        [appDelegate.account setAccount:nil];
        [appDelegate.account setPassword:nil];
    }
    NSError *error = nil;
    if (![[appDelegate managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result {
   NSError* error;
   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:&error];
   if ([json count] > 0) {
      if ([command isEqualToString:@"logout"]) {
         if ([json objectForKey:@"error"] || json == nil) {
            [self.appDelegate setCurrentPassword:nil];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:BALocalizedString(@"Bei der Abmeldung ist ein Fehler aufgetreten")
                                                            message:[[NSString alloc] initWithFormat:@"%@ - %@", [json objectForKey:@"code"], [json objectForKey:@"error"]]
                                                           delegate:self cancelButtonTitle:BALocalizedString(@"OK") otherButtonTitles:nil];
            [alert setTag:1];
            [alert show];
         } else {
            [self.appDelegate setCurrentAccount:nil];
            [self.appDelegate setCurrentPassword:nil];
            [self.appDelegate setCurrentToken:nil];
            [self.appDelegate setCurrentScope:nil];
            [self.appDelegate setIsLoggedIn:NO];
            [self.userLabel setText:BALocalizedString(@"Nicht angemeldet")];
            [self.logoutButton setEnabled:NO];
         }
      }
   }
}

- (void)viewDidUnload {
    [self setVersionLabel:nil];
    [self setCatalogueLabel:nil];
    [self setCountPixelSwitch:nil];
    [super viewDidUnload];
}

- (void)commandIsNotInScope:(NSString *)command {
   // ToDo: reset state if necessary
}

- (void)networkIsNotReachable:(NSString *)command {
   // ToDo: reset state if necessary
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return BALocalizedString(@"Suche");
    } else if (section == 1) {
        return BALocalizedString(@"Sprache");
    } else if (section == 2) {
        return BALocalizedString(@"Konto");
    } else if (section == 3) {
        return BALocalizedString(@"Datenschutz");
    } else if (section == 4) {
        return BALocalizedString(@"Info");
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 3) {
        return BALocalizedString(@"Wenn Sie diese Option deaktivieren, werden keine anonymisierten Nutzungsdaten gespeichert. Weitere Hinweise s. Info / Impressum");
    }
    return nil;
}

@end
