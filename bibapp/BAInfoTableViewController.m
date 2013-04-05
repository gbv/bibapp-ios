//
//  BAInfoTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 28.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAInfoTableViewController.h"
#import "BAInfoCell.h"
#import "GDataXMLNode.h"
#import "BAConnector.h"
#import "BAInfoItem.h"
#include <UIKit/UIKit.h>

@interface BAInfoTableViewController ()

@end

@implementation BAInfoTableViewController

@synthesize infoFeed;

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
    
    [self.navigationController.navigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    self.infoFeed = [[NSMutableArray alloc] init];
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [spinner startAnimating];
    spinner.frame = CGRectMake(0, 0, 320, 44);
    self.infoTableView.tableFooterView = spinner;
    
    BAConnector *connector = [BAConnector generateConnector];
    [connector getInfoFeedWithDelegate:self];
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
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section != 3) {
        return 1;
    } else {
        return [self.infoFeed count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (indexPath.section == 0) {
            [cell.textLabel setText:@"Kontakt"];
        } else if (indexPath.section == 1) {
            [cell.textLabel setText:@"Standorte"];
        } else if (indexPath.section == 2) {
            [cell.textLabel setText:@"Impressum"];
        }
        return cell;
    } else {
        BAInfoCell *cell;
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAInfoCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        [cell.titleLabel setText:[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] title]];
        [cell.dateLabel setText:[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] date]];
        if (![[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] content] isEqualToString:@""]) {
            [cell.contentLabel setText:[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] content]];
        } else {
            [cell.contentLabel setText:[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] description]];
        }
        [cell.contentLabel sizeToFit];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"BAKontaktSegue" sender:self];
    } else if (indexPath.section == 1) {
        [self performSegueWithIdentifier:@"BAStandortSegue" sender:self];
    } else if (indexPath.section == 2) {
        [self performSegueWithIdentifier:@"BAImpressumSegue" sender:self];
    } else if (indexPath.section == 3) {
        NSURL *url = [NSURL URLWithString:[(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] link]];
        if (![[UIApplication sharedApplication] openURL:url]) {
            NSLog(@"%@%@",@"Failed to open url:",[url description]);
        }
    }
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
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
            if ([detailItem.name isEqualToString:@"content:encoded"]) {
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
    self.infoTableView.tableFooterView = nil;
    [self.infoTableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section != 3) {
        return 42;
    } else {
        NSString *text;
        if (![[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] content] isEqualToString:@""]) {
            text = [(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] content];
        } else {
            text = [(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] description];
        }
        CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(260, 10000.0f)];
        return textSize.height + 80;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section != 3)
    {
        return @"";
    } else {
        return @"News";
    }
}

@end
