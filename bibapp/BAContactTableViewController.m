//
//  BAContactTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 04.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAContactTableViewController.h"
#import "BAImpressumCell.h"
#import "BALocalizeHelper.h"

@interface BAContactTableViewController ()

@end

@implementation BAContactTableViewController

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
    
    [self.navigationItem setTitle:BALocalizedString(@"Kontakt")];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = BALocalizedString(@"Info");
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.contactText setText:appDelegate.configuration.currentBibContact];
    CGRect frame = self.contactText.frame;
    frame.size.height = self.contactText.contentSize.height;
    self.contactText.frame = frame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentObject = self.contactText.text;
    CGSize textSize = [(NSString *)currentObject sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(280, FLT_MAX)];
    return textSize.height + 60;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return BALocalizedString(@"Kontakt");
}

@end
