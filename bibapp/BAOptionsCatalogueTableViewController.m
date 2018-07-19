//
//  BAOptionsCatalogueTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 02.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAOptionsCatalogueTableViewController.h"
#import "BACatalogueTableViewCell.h"

@interface BAOptionsCatalogueTableViewController ()

@end

@implementation BAOptionsCatalogueTableViewController

@synthesize appDelegate;
@synthesize selectedCellIndex;

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
    
    [self setSelectedCellIndex:-1];
}

- (void)didReceiveMemoryWarning
{
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
    return [self.appDelegate.configuration.currentBibLocalSearchURLs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BACatalogueTableViewCell *cell;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BACatalogueTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    [cell.catalogueLabel setText:[[self.appDelegate.configuration.currentBibLocalSearchURLs objectAtIndex:indexPath.row] objectAtIndex:1]];
    if ([self.appDelegate.options.selectedCatalogue isEqualToString:[[self.appDelegate.configuration.currentBibLocalSearchURLs objectAtIndex:indexPath.row] objectAtIndex:1]]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        if (self.selectedCellIndex == -1) {
            [self setSelectedCellIndex:indexPath.row];
        }
    } else {
        [cell setAccessoryType:nil];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.appDelegate.options.selectedCatalogue isEqualToString:[[self.appDelegate.configuration.currentBibLocalSearchURLs objectAtIndex:indexPath.row] objectAtIndex:1]]) {
        [self.appDelegate.options setSelectedCatalogue:[[self.appDelegate.configuration.currentBibLocalSearchURLs objectAtIndex:indexPath.row] objectAtIndex:1]];
        
        NSError *error = nil;
        if (![[appDelegate managedObjectContext] save:&error]) {
            // Handle the error.
        }
        
        UITableViewCell *selectedCellOld = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedCellIndex inSection:indexPath.section]];
        [selectedCellOld setAccessoryType:nil];
        
        UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        [selectedCell setAccessoryType:UITableViewCellAccessoryCheckmark];
        
        [self setSelectedCellIndex:indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCatalogue" object:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
