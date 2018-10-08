//
//  BALanguageTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 18.07.18.
//  Copyright © 2018 Johannes Schultze. All rights reserved.
//

#import "BAOptionsLanguageTableViewController.h"
#import "BACatalogueTableViewCell.h"
#import "BALocalizeHelper.h"

@interface BAOptionsLanguageTableViewController ()

@end

@implementation BAOptionsLanguageTableViewController

@synthesize appDelegate;
@synthesize selectedCellIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationItem setTitle:BALocalizedString(@"Sprache")];
    
    [self setSelectedCellIndex:-1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.appDelegate.configuration.currentBibLanguages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BACatalogueTableViewCell *cell;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BACatalogueTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    NSArray *languageKeys = [self.appDelegate.configuration.currentBibLanguages allKeys];
    id languageKey = [languageKeys objectAtIndex:indexPath.row];
    
    [cell.catalogueLabel setText: BALocalizedString(languageKey)];
    if ([self.appDelegate.options.selectedLanguage isEqualToString:languageKey]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        if (self.selectedCellIndex == -1) {
            [self setSelectedCellIndex:indexPath.row];
        }
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *languageKeys = [self.appDelegate.configuration.currentBibLanguages allKeys];
    id languageKey = [languageKeys objectAtIndex:indexPath.row];
    
    if (![self.appDelegate.options.selectedLanguage isEqualToString:languageKey]) {
        [self.appDelegate.options setSelectedLanguage:languageKey];
        
        BALocalizationSetLanguage(self.appDelegate.options.selectedLanguage);
        
        NSError *error = nil;
        if (![[appDelegate managedObjectContext] save:&error]) {
            // Handle the error.
        }
        
        UITableViewCell *selectedCellOld = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedCellIndex inSection:indexPath.section]];
        [selectedCellOld setAccessoryType:UITableViewCellAccessoryNone];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        [self setSelectedCellIndex:indexPath.row];
        
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
        
        [self reloadRootViewController];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)reloadRootViewController
{
    NSString *storyboardName = @"bibapp~iphone";
    UIStoryboard *storybaord = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    self.appDelegate.window.rootViewController = [storybaord instantiateInitialViewController];
}

@end