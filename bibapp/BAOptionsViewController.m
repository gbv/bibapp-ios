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
    
    [self.navigationController.navigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.options.saveLocalData) {
        [self.saveLocalSwitch setOn:YES];
        self.pushSwitch.enabled = YES;
    } else {
        self.pushSwitch.enabled = NO;
    }
    if (!appDelegate.options.allowCountPixel) {
        [self.countPixelSwitch setOn:NO];
    }
    if (appDelegate.account.pushServerId) {
        [self.pushSwitch setOn:YES];
    }
    
    [self.catalogueLabel setText:self.appDelegate.options.selectedCatalogue];
    [self.versionLabel setText:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.catalogueLabel setText:self.appDelegate.options.selectedCatalogue];
   
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.saveLocalSwitch.enabled = NO;
    if (appDelegate.currentAccount && appDelegate.currentPassword) {
        self.saveLocalSwitch.enabled = YES;
    }
    
    if (self.appDelegate.currentAccount != nil) {
       [self.userLabel setText:self.appDelegate.currentAccount];
       [self.logoutButton setEnabled:YES];
    } else {
       [self.userLabel setText:@"Nicht angemeldet"];
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

- (IBAction)pushAction:(id)sender {
    if ([sender isOn]) {
        [self.appDelegate.pushService enablePush];
    } else {
        [self.appDelegate.pushService disablePush];
    }
}

- (IBAction)saveLocalSwithAction:(id)sender
{
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([sender isOn]) {
        [appDelegate.options setSaveLocalData:YES];
        [appDelegate.account setAccount:appDelegate.currentAccount];
        [appDelegate.account setPassword:appDelegate.currentPassword];
        self.pushSwitch.enabled = YES;
    } else {
        [appDelegate.options setSaveLocalData:NO];
        [appDelegate.account setAccount:nil];
        [appDelegate.account setPassword:nil];
        [self.pushSwitch setOn:NO];
        self.pushSwitch.enabled = NO;
        [self.appDelegate.pushService disablePush];
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
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Bei der Abmeldung ist ein Fehler aufgetreten"
                                                            message:[[NSString alloc] initWithFormat:@"%@ - %@", [json objectForKey:@"code"], [json objectForKey:@"error"]]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setTag:1];
            [alert show];
         } else {
            [self.appDelegate setCurrentAccount:nil];
            [self.appDelegate setCurrentPassword:nil];
            [self.appDelegate setCurrentToken:nil];
            [self.appDelegate setCurrentScope:nil];
            [self.appDelegate setIsLoggedIn:NO];
            [self.userLabel setText:@"Nicht angemeldet"];
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

@end
