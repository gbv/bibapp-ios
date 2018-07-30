//
//  BAImpressumTableViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 19.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAImpressumTableViewController.h"
#import "BAImpressumCell.h"
#import "BALocalizeHelper.h"

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
    
    [self.navigationItem setTitle:BALocalizedString(@"Impressum")];
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
   // Refactor: reuse cell.
   BAImpressumCell *cell;
   NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAImpressumCell" owner:self options:nil];
   cell = [nib objectAtIndex:0];
    
   id currentObject = [self getImprintTextForKey:[self getImprintKeyForSection:indexPath.section]];
    
   [cell.impressumLabel setText:(NSString *)currentObject];
   [cell.impressumLabel sizeToFit];
    
   return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self getImprintKeyForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id currentObject = [self getImprintTextForKey:[self getImprintKeyForSection:indexPath.section]];
    CGSize textSize = [(NSString *)currentObject sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:CGSizeMake(280, FLT_MAX)];
    return textSize.height + 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (NSString *)getImprintKeyForSection:(NSInteger)section
{
    if ([self.appDelegate.configuration.currentBibImprintTitlesLocalized count] > 0) {
        NSArray *translations = [self.appDelegate.configuration.currentBibImprintTitlesLocalized objectForKey:self.appDelegate.options.selectedLanguage];
        if ([translations isEqual:[NSNull null]]) {
            translations = [self.appDelegate.configuration.currentBibImprintTitlesLocalized objectForKey:self.appDelegate.configuration.currentBibStandardLanguage];
        }
        return (NSString *)[translations objectAtIndex:section];
    }
    return (NSString *)[self.appDelegate.configuration.currentBibImprintTitles objectAtIndex:section];
}

- (NSString *)getImprintTextForKey:(NSString *)key
{
    if ([self.appDelegate.configuration.currentBibImprintLocalized count] > 0) {
        NSDictionary *translations = [self.appDelegate.configuration.currentBibImprintLocalized objectForKey:self.appDelegate.options.selectedLanguage];
        if ([translations isEqual:[NSNull null]]) {
            translations = [self.appDelegate.configuration.currentBibImprintLocalized objectForKey:self.appDelegate.configuration.currentBibStandardLanguage];
        }
        return (NSString *)[translations objectForKey:key];
    }
    return [self.appDelegate.configuration.currentBibImprint objectForKey:key];
}

@end
