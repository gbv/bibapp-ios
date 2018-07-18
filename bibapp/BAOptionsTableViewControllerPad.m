//
//  BAOptionsTableViewControllerPad.m
//  bibapp
//
//  Created by Johannes Schultze on 02.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAOptionsTableViewControllerPad.h"
#import "BAConnector.h"
#import "BAOptionsNavigationController.h"

@interface BAOptionsTableViewControllerPad ()

@end

@implementation BAOptionsTableViewControllerPad

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController.navigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.options.saveLocalData) {
        [self.saveLocalSwitch setOn:YES];
    }
    if (!appDelegate.options.allowCountPixel) {
        [self.countPixelSwitch setOn:NO];
    }
    
    [self.catalogueLabel setText:self.appDelegate.options.selectedCatalogue];
    [self.versionLabel setText:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.catalogueLabel setText:self.appDelegate.options.selectedCatalogue];
}

- (void)viewWillAppear:(BOOL)animated {
   [super viewWillAppear:animated];
   if (self.appDelegate.currentAccount != nil) {
      [self.userLabel setText:self.appDelegate.currentAccount];
      [self.logoutButton setEnabled:YES];
   } else {
      [self.userLabel setText:NSLocalizedString(@"Nicht angemeldet", nil)];
      [self.logoutButton setEnabled:NO];
   }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}*/

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}*/

/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)viewDidUnload {
    [self setSaveLocalSwitch:nil];
    [self setCountPixelSwitch:nil];
    [self setCatalogueLabel:nil];
    [self setVersionLabel:nil];
    [super viewDidUnload];
}

- (IBAction)saveLocalSwitchAction:(id)sender {
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

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result {
   NSError* error;
   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:&error];
   if ([json count] > 0) {
      if ([command isEqualToString:@"logout"]) {
         if ([json objectForKey:@"error"] || json == nil) {
            [self.appDelegate setCurrentPassword:nil];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bei der Abmeldung ist ein Fehler aufgetreten", nil)
                                                            message:[[NSString alloc] initWithFormat:@"%@ - %@", [json objectForKey:@"code"], [json objectForKey:@"error"]]
                                                           delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
            [alert setTag:1];
            [alert show];
         } else {
            [self.appDelegate setCurrentAccount:nil];
            [self.appDelegate setCurrentPassword:nil];
            [self.appDelegate setCurrentToken:nil];
            [self.appDelegate setCurrentScope:nil];
            [self.appDelegate setIsLoggedIn:NO];
            [self.userLabel setText:NSLocalizedString(@"Nicht angemeldet", nil)];
            [self.logoutButton setEnabled:NO];
            if (((BAOptionsNavigationController *)self.navigationController).accountViewController != nil) {
               [((BAOptionsNavigationController *)self.navigationController).accountViewController reset];
            }
         }
      }
   }
}

- (void)commandIsNotInScope:(NSString *)command {
   // ToDo: reset state if necessary
}

- (void)networkIsNotReachable:(NSString *)command {
   // ToDo: reset state if necessary
}

@end
