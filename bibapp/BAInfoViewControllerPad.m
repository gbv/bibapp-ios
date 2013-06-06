//
//  BAInfoTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 28.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAInfoViewControllerPad.h"
#import "BAInfoCell.h"
#import "GDataXMLNode.h"
#import "BAConnector.h"
#import "BAInfoItem.h"
#import "BAImpressumCellPad.h"
#import "BALocationCellPad.h"
#import "BALocationViewControllerPad.h"
#include <UIKit/UIKit.h>

@interface BAInfoViewControllerPad ()

@end

@implementation BAInfoViewControllerPad

@synthesize infoNavigationBar;
@synthesize infoTableView;
@synthesize infoFeed;
@synthesize contentTableView;
@synthesize locationList;
@synthesize currentLocation;

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

    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.infoNavigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    self.infoFeed = [[NSMutableArray alloc] init];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.contentTableView.tableFooterView = spinner;
    
    BAConnector *connector = [BAConnector generateConnector];
    [connector getInfoFeedWithDelegate:self];
    
    self.locationList = [[NSMutableArray alloc] init];
    
    BAConnector *locationConnector = [BAConnector generateConnector];
    [locationConnector getLocationsForLibraryByUri:self.appDelegate.configuration.currentBibLocationUri WithDelegate:self];
    
    [self.infoTableView setTag:0];
    [self.contentTableView setTag:1];
    
    [self.infoTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView.tag == 0) {
        return 4;
    } else {
        if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
            return 1;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
            return 1;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
            return 1;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 3) {
            return 1;
        } else {
            return 0;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return 1;
    } else {
        if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
            return [self.infoFeed count];
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
            return 1;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
            return [self.locationList count];
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 3) {
            return [self.appDelegate.configuration.currentBibImprint count];
        } else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        if (indexPath.section == 0) {
            [cell.textLabel setText:@"News"];
        } else if (indexPath.section == 1) {
            [cell.textLabel setText:@"Kontakt"];
        } else if (indexPath.section == 2) {
            [cell.textLabel setText:@"Standorte"];
        } else if (indexPath.section == 3) {
            [cell.textLabel setText:@"Impressum"];
        }
        [cell setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
        return cell;
    } else {
        if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
            BAInfoCell *cell;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAInfoCellPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell.titleLabel setText:[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] title]];
            [cell.dateLabel setText:[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] date]];
            if (![[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] content] isEqualToString:@""]) {
                [cell.contentLabel setText:[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] content]];
            } else {
                [cell.contentLabel setText:[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] description]];
            }
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            [cell.contentLabel sizeToFit];
            return cell;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
            BAInfoCell *cell;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAInfoCellPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell.titleLabel setText:@"Kontakt"];
            [cell.dateLabel setText:@""];
            [cell.contentLabel setText:self.appDelegate.configuration.currentBibContact];
            [cell.contentLabel sizeToFit];
            return cell;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
            BALocationCellPad *cell;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BALocationCellPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            [cell.locationLabel setText:[(BALocation *)[self.locationList objectAtIndex:indexPath.row] name]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            return cell;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 3) {
            BAImpressumCellPad *cell;
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAImpressumCellPad" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            id currentObject = [self.appDelegate.configuration.currentBibImprint objectForKey:[self.appDelegate.configuration.currentBibImprintTitles objectAtIndex:indexPath.row]];
            [cell.impressumLabel setText:(NSString *)currentObject];
            [cell.impressumLabel sizeToFit];
            return cell;
        } else {
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        [self.contentTableView reloadData];
    } else {
        if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
            NSURL *url = [NSURL URLWithString:[(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] link]];
            if (![[UIApplication sharedApplication] openURL:url]) {
            }
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
            self.currentLocation = [self.locationList objectAtIndex:indexPath.row];
            [self performSegueWithIdentifier:@"locationSegue" sender:self];
        }
    }
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
    if ([command isEqualToString:@"getInfoFeedWithDelegate"]) {
        GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
        NSArray *items = [parser nodesForXPath:@"/rss/channel/item" error:nil];
        for (GDataXMLElement *item in items) {
            BAInfoItem *tempInfoItem = [[BAInfoItem alloc] init];
            [tempInfoItem setTitle:[[[item nodesForXPath:@"title" error:nil] objectAtIndex:0] stringValue]];
            
            NSDateFormatter *importFormat = [[NSDateFormatter alloc] init];
            NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
            [importFormat setLocale:enUS];
            [importFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss z"];
            NSDate *tempDate =  [importFormat dateFromString:[[[item nodesForXPath:@"pubDate" error:nil] objectAtIndex:0] stringValue]];

            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEEE, dd.MM.yyyy"];
            
            [tempInfoItem setDate:[dateFormat stringFromDate:tempDate]];
            [tempInfoItem setDescription:[[[item nodesForXPath:@"description" error:nil] objectAtIndex:0] stringValue]];
            
            [self.infoFeed addObject:tempInfoItem];
            for (GDataXMLElement *detailItem in item.children) {
                if([detailItem.name isEqualToString:@"content:encoded"]){
                    NSString *tempContent = [detailItem stringValue];
                    tempContent = [tempContent stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\\n"];
                    tempContent = [tempContent stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
                    tempContent = [tempContent stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
                    
                    NSRegularExpression *regexHTML = [NSRegularExpression regularExpressionWithPattern:@"<[^<]+?>" options:NSRegularExpressionCaseInsensitive error:nil];
                    tempContent = [regexHTML stringByReplacingMatchesInString:tempContent options:0 range:NSMakeRange(0, [tempContent length]) withTemplate:@""];
                    
                    NSRegularExpression *regexWhitespace = [NSRegularExpression regularExpressionWithPattern:@" +" options:NSRegularExpressionCaseInsensitive error:nil];
                    tempContent = [regexWhitespace stringByReplacingMatchesInString:tempContent options:0 range:NSMakeRange(0, [tempContent length]) withTemplate:@" "];
                    
                    [tempInfoItem setContent:tempContent];
                }
            }
            [tempInfoItem setLink:[[[item nodesForXPath:@"link" error:nil] objectAtIndex:0] stringValue]];
        }
        self.contentTableView.tableFooterView = nil;
        [self.contentTableView reloadData];
    } else if ([command isEqualToString:@"getLocationsForLibraryByUri"]) {
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
        [self.contentTableView reloadData];
        self.contentTableView.tableFooterView = nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
            NSString *text;
            if (![[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] content] isEqualToString:@""]) {
                text = [(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] content];
            } else {
                text = [(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] description];
            }
            CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(576, 10000.0f)];
            return textSize.height + 80;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
            CGSize textSize = [self.appDelegate.configuration.currentBibContact sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(556, 10000.0f)];
            return textSize.height + 80;
        } else if ([[self.infoTableView indexPathForSelectedRow] section] == 3) {
            id currentObject = [self.appDelegate.configuration.currentBibImprint objectForKey:[self.appDelegate.configuration.currentBibImprintTitles objectAtIndex:indexPath.row]];
            CGSize textSize = [(NSString *)currentObject sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(556, 10000.0f)];
            return textSize.height + 40;
        } else {
            return 46;
        }
    } else {
        return 46;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"locationSegue"]) {
        BALocationViewControllerPad *locationViewController = (BALocationViewControllerPad *)[segue destinationViewController];
        [locationViewController setCurrentLocation:self.currentLocation];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidUnload
{
    [self setContentTableView:nil];
    [super viewDidUnload];
}

@end
