//
//  BAContactTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 04.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAContactTableViewController.h"
#import "BAImpressumCell.h"

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
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.contactText setText:appDelegate.configuration.currentBibContact];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContactText:nil];
    [super viewDidUnload];
}

@end
