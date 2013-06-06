//
//  BALocationTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 07.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BALocationTableViewController.h"
#import "BAConnector.h"
#import "BALocationViewControllerIPhone.h"

@interface BALocationTableViewController ()

@end

@implementation BALocationTableViewController

@synthesize appDelegate;
@synthesize locationList;
@synthesize currentLocation;
@synthesize didReturnFromSegue;

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
    self.locationList = [[NSMutableArray alloc] init];
    self.didReturnFromSegue = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.didReturnFromSegue) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, 320, 44);
        self.tableView.tableFooterView = spinner;
        
        BAConnector *locationConnector = [BAConnector generateConnector];
        [locationConnector getLocationsForLibraryByUri:appDelegate.configuration.currentBibLocationUri WithDelegate:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
    if ([command isEqualToString:@"getLocationsForLibraryByUri"]) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
        BAConnector *locationConnector = [BAConnector generateConnector];
        BALocation *tempLocationMain = [locationConnector loadLocationForUri:self.appDelegate.configuration.currentBibLocationUri];
        [self.locationList addObject:tempLocationMain];
        for (NSString *key in [json objectForKey:self.appDelegate.configuration.currentBibLocationUri]) {
            if ([key isEqualToString:@"http://www.w3.org/ns/org#hasSite"]) {
                for (NSDictionary *tempUri in [[json objectForKey:self.appDelegate.configuration.currentBibLocationUri] objectForKey:key]) {
                    BALocation *tempLocation = [locationConnector loadLocationForUri:[tempUri objectForKey:@"value"]];
                    if ([tempLocation.address isEqualToString:@""]) {
                        [tempLocation setAddress:tempLocationMain.address];
                        [tempLocation setGeoLong:tempLocationMain.geoLong];
                        [tempLocation setGeoLat:tempLocationMain.geoLat];
                    }
                    [self.locationList addObject:tempLocation];
                }
            }
        }
        [self.tableView reloadData];
        self.tableView.tableFooterView = nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.locationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"LocationListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    [cell.textLabel setText:[(BALocation *)[self.locationList objectAtIndex:indexPath.row] name]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currentLocation = [self.locationList objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ItemDetailLocationSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.didReturnFromSegue = YES;
    if ([[segue identifier] isEqualToString:@"ItemDetailLocationSegue"]) {
        BALocationViewControllerIPhone *locationViewController = (BALocationViewControllerIPhone *)[segue destinationViewController];
        [locationViewController setCurrentLocation:self.currentLocation];
    }
}

@end
