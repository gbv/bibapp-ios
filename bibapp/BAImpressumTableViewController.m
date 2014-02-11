//
//  BAImpressumTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 19.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAImpressumTableViewController.h"
#import "BAImpressumCell.h"

@interface BAImpressumTableViewController ()

@end

@implementation BAImpressumTableViewController

@synthesize appDelegate;

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
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.appDelegate.configuration.currentBibImprint count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BAImpressumCell *cell;
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAImpressumCell" owner:self options:nil];
    cell = [nib objectAtIndex:0];
    
    id currentObject = [self.appDelegate.configuration.currentBibImprint objectForKey:[self.appDelegate.configuration.currentBibImprintTitles objectAtIndex:indexPath.section]];
    
    [cell.impressumLabel setText:(NSString *)currentObject];
    [cell.impressumLabel sizeToFit];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (NSString *)[self.appDelegate.configuration.currentBibImprintTitles objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentObject = [self.appDelegate.configuration.currentBibImprint objectForKey:[self.appDelegate.configuration.currentBibImprintTitles objectAtIndex:indexPath.section]];
    CGSize textSize = [(NSString *)currentObject sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(280, FLT_MAX)];
    return textSize.height + 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
