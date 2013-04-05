//
//  BATocListTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 26.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BATocListTableViewController.h"
#import "BATocViewController.h"
#import "BATocListCell.h"

@interface BATocListTableViewController ()

@end

@implementation BATocListTableViewController

@synthesize tocArray;
@synthesize currentToc;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setTocArray:[[NSMutableArray alloc] init]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return [self.tocArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATocListCell *cell;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BATocListCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    [cell.tocLabel setText:[self.tocArray objectAtIndex:indexPath.row]];
    
    UIImage *tocImage;
    if ([[[self.tocArray objectAtIndex:indexPath.row] substringFromIndex:0] hasSuffix:@".pdf"] || [[[self.tocArray objectAtIndex:indexPath.row] substringFromIndex:0] hasSuffix:@".PDF"]) {
        tocImage = [UIImage imageNamed:@"mediaIconT.png"];
    } else {
        tocImage = [UIImage imageNamed:@"mediaIconO.png"];
    }
    [cell.tocIcon setImage:tocImage];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCurrentToc:[tocArray objectAtIndex:indexPath.row]];
    [self performSegueWithIdentifier:@"tocSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"tocSegue"]) {
        BATocViewController *tocViewController = (BATocViewController *)[segue destinationViewController];
        [tocViewController setUrl:self.currentToc];
    }
}

@end
