//
//  BATocTableViewControllerPad.m
//  bibapp
//
//  Created by Johannes Schultze on 19.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BATocTableViewControllerPad.h"
#import "BATocCellPad.h"
#import "BATocViewControllerPad.h"

@interface BATocTableViewControllerPad ()

@end

@implementation BATocTableViewControllerPad

@synthesize tocArray;
@synthesize searchController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.tocArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tocArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BATocCellPad *cell;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BATocCellPad" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    [cell.locationLabel setText:[self.tocArray objectAtIndex:indexPath.row]];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setCurrentToc:[self.tocArray objectAtIndex:indexPath.row]];
    [self.searchController performSegueWithIdentifier:@"tocSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"tocSegue"]) {
        BATocViewControllerPad *tocViewController = (BATocViewControllerPad *)[segue destinationViewController];
        [tocViewController setUrl:self.currentToc];
    }
}

@end
