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
#import "BALocalizeHelper.h"

@interface BAInfoViewControllerPad ()

@end

@implementation BAInfoViewControllerPad

@synthesize infoNavigationBar;
@synthesize infoTableView;
@synthesize infoFeed;
@synthesize contentTableView;
@synthesize locationList;
@synthesize currentLocation;
@synthesize statusBarTintUIView;
@synthesize didLoadLocations;

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

    self.didLoadLocations = NO;
   
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];

    if (self.appDelegate.isIOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
        //[self.statusBarTintUIView setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.infoNavigationBar setBarTintColor:self.appDelegate.configuration.currentBibTintColor];
        //[self.optionsButton setTintColor:[UIColor whiteColor]];
    } else {
        [self.statusBarTintUIView setHidden:YES];
        [self.infoNavigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    }
    
    if (![self.appDelegate.configuration.currentBibFeedURL isEqualToString:@""]) {
       if (!self.appDelegate.configuration.currentBibFeedURLIsWebsite) {
          self.infoFeed = [[NSMutableArray alloc] init];
    
          UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
          [spinner startAnimating];
          spinner.frame = CGRectMake(0, 0, 320, 44);
          self.contentTableView.tableFooterView = spinner;
    
          BAConnector *connector = [BAConnector generateConnector];
          [connector getInfoFeedWithDelegate:self];
       }
    }
    
    self.locationList = [[NSMutableArray alloc] init];
   
    [self performSelectorInBackground:@selector(loadLocations) withObject:nil];
    
    [self.infoTableView setTag:0];
    [self.contentTableView setTag:1];
    
    [self.infoTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)loadLocations {
   BAConnector *locationConnector = [BAConnector generateConnector];
   [locationConnector getLocationsForLibraryByUri:[self.appDelegate.configuration getLocationURIForCatalog:self.appDelegate.options.selectedCatalogue] WithDelegate:self];
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
        if (![self.appDelegate.configuration.currentBibFeedURL isEqualToString:@""]) {
            return 4;
        } else {
            return 3;
        }
    } else {
        if (![self.appDelegate.configuration.currentBibFeedURL isEqualToString:@""]) {
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
        } else {
            if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
                return 1;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
                return 1;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
                return 1;
            } else {
                return 0;
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 0) {
        return 1;
    } else {
        if (![self.appDelegate.configuration.currentBibFeedURL isEqualToString:@""]) {
           if (!self.appDelegate.configuration.currentBibFeedURLIsWebsite) {
              if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
                 return [self.infoFeed count];
              } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
                 return 1;
              } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
                 if (self.didLoadLocations) {
                    return [self.locationList count];
                 } else {
                    return 1;
                 }
              } else if ([[self.infoTableView indexPathForSelectedRow] section] == 3) {
                 return [self.appDelegate.configuration.currentBibImprint count];
              } else {
                 return 0;
              }
           } else {
              if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
                 return 1;
              } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
                 return 1;
              } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
                 if (self.didLoadLocations) {
                    return [self.locationList count];
                 } else {
                    return 1;
                 }
              } else if ([[self.infoTableView indexPathForSelectedRow] section] == 3) {
                 return [self.appDelegate.configuration.currentBibImprint count];
              } else {
                 return 0;
              }
           }
        } else {
            if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
                return 1;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
               if (self.didLoadLocations) {
                  return [self.locationList count];
               } else {
                  return 1;
               }
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
                return [self.appDelegate.configuration.currentBibImprint count];
            } else {
                return 0;
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView.tag == 0) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
        
        if (![self.appDelegate.configuration.currentBibFeedURL isEqualToString:@""]) {
           if (!self.appDelegate.configuration.currentBibFeedURLIsWebsite) {
              if (indexPath.section == 0) {
                 [cell.textLabel setText:BALocalizedString(@"News")];
              } else if (indexPath.section == 1) {
                 [cell.textLabel setText:BALocalizedString(@"Kontakt")];
              } else if (indexPath.section == 2) {
                 [cell.textLabel setText:BALocalizedString(@"Standorte")];
              } else if (indexPath.section == 3) {
                 [cell.textLabel setText:BALocalizedString(@"Impressum")];
              }
           } else {
              if (indexPath.section == 0) {
                 [cell.textLabel setText:BALocalizedString(@"Website")];
              } else if (indexPath.section == 1) {
                 [cell.textLabel setText:BALocalizedString(@"Kontakt")];
              } else if (indexPath.section == 2) {
                 [cell.textLabel setText:BALocalizedString(@"Standorte")];
              } else if (indexPath.section == 3) {
                 [cell.textLabel setText:BALocalizedString(@"Impressum")];
              }
           }
        } else {
            if (indexPath.section == 0) {
                [cell.textLabel setText:BALocalizedString(@"Kontakt")];
            } else if (indexPath.section == 1) {
                [cell.textLabel setText:BALocalizedString(@"Standorte")];
            } else if (indexPath.section == 2) {
                [cell.textLabel setText:BALocalizedString(@"Impressum")];
            }
        }
        return cell;
    } else {
        if (![self.appDelegate.configuration.currentBibFeedURL isEqualToString:@""]) {
            if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
               if (!self.appDelegate.configuration.currentBibFeedURLIsWebsite) {
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
               } else {
                  UITableViewCell *cell = [[UITableViewCell alloc] init];
                  [cell.textLabel setText:[self.appDelegate.configuration getFeedURLForCatalog:self.appDelegate.options.selectedCatalogue]];
                  return cell;
               }
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
                BAInfoCell *cell;
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAInfoCellPad" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.titleLabel setText:BALocalizedString(@"Kontakt")];
                [cell.dateLabel setText:@""];
                [cell.contentLabel setText:self.appDelegate.configuration.currentBibContact];
                [cell.contentLabel sizeToFit];
                return cell;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
                BALocationCellPad *cell;
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BALocationCellPad" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                if (self.didLoadLocations) {
                   [cell.locationLabel setText:[(BALocation *)[self.locationList objectAtIndex:indexPath.row] name]];
                   [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                } else {
                   [cell.locationLabel setText:BALocalizedString(@"Standorte werden geladen ...")];
                }
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
        } else {
            if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
                BAInfoCell *cell;
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BAInfoCellPad" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.titleLabel setText:BALocalizedString(@"Kontakt")];
                [cell.dateLabel setText:@""];
                [cell.contentLabel setText:self.appDelegate.configuration.currentBibContact];
                [cell.contentLabel sizeToFit];
                return cell;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
                BALocationCellPad *cell;
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BALocationCellPad" owner:self options:nil];
                cell = [nib objectAtIndex:0];
                [cell.locationLabel setText:[(BALocation *)[self.locationList objectAtIndex:indexPath.row] name]];
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                return cell;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
        [[tableView cellForRowAtIndexPath:indexPath].textLabel setTextColor:[UIColor whiteColor]];
        [self.contentTableView reloadData];
    } else {
        if (![self.appDelegate.configuration.currentBibFeedURL isEqualToString:@""]) {
            if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
                NSURL *url;
                if (!self.appDelegate.configuration.currentBibFeedURLIsWebsite) {
                   url = [NSURL URLWithString:[(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] link]];
                } else {
                   url = [NSURL URLWithString:[self.appDelegate.configuration getFeedURLForCatalog:self.appDelegate.options.selectedCatalogue]];
                }
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
                self.currentLocation = [self.locationList objectAtIndex:indexPath.row];
                [self performSegueWithIdentifier:@"locationSegue" sender:self];
            }
        } else {
            if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
                self.currentLocation = [self.locationList objectAtIndex:indexPath.row];
                [self performSegueWithIdentifier:@"locationSegue" sender:self];
            }
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
       self.didLoadLocations = YES;
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
        BAConnector *locationConnector = [BAConnector generateConnector];
        BALocation *tempLocationMain = [locationConnector loadLocationForUri:[self.appDelegate.configuration getLocationURIForCatalog:self.appDelegate.options.selectedCatalogue]];
        if (tempLocationMain != nil) {
            [self.locationList addObject:tempLocationMain];
            for (NSString *key in [json objectForKey:[self.appDelegate.configuration getLocationURIForCatalog:self.appDelegate.options.selectedCatalogue]]) {
                if ([key isEqualToString:@"http://www.w3.org/ns/org#hasSite"]) {
                    for (NSDictionary *tempUri in [[json objectForKey:[self.appDelegate.configuration getLocationURIForCatalog:self.appDelegate.options.selectedCatalogue]] objectForKey:key]) {
                        BAConnector *tempLocationConnector = [BAConnector generateConnector];
                        [tempLocationConnector loadLocationForUri:[tempUri objectForKey:@"value"] WithDelegate:self];
                    }
                }
            }
        }
        [self.contentTableView reloadData];
        self.contentTableView.tableFooterView = nil;
    } else if ([command isEqualToString:@"loadLocationForUri"]) {
        [self.locationList addObject:(BALocation *)result];
        [self.contentTableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        if (![self.appDelegate.configuration.currentBibFeedURL isEqualToString:@""]) {
            if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
                NSString *text;
                if (![[(BAInfoItem *)[self.infoFeed objectAtIndex:indexPath.row] content] isEqualToString:@""]) {
                    text = [(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] content];
                } else {
                    text = [(BAInfoItem *)[self.infoFeed objectAtIndex:[indexPath row]] description];
                }
                CGRect textRect = [text boundingRectWithSize:CGSizeMake(576, 10000.0f)
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                     context:nil];
                return textRect.size.height + 80;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 1) {
                CGRect textRect = [self.appDelegate.configuration.currentBibContact boundingRectWithSize:CGSizeMake(556, 10000.0f)
                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                                                                 context:nil];
                return textRect.size.height + 80;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 3) {
                id currentObject = [self.appDelegate.configuration.currentBibImprint objectForKey:[self.appDelegate.configuration.currentBibImprintTitles objectAtIndex:indexPath.row]];
                CGRect textRect = [(NSString *)currentObject boundingRectWithSize:CGSizeMake(556, 10000.0f)
                                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                                          context:nil];
                return textRect.size.height + 40;
            } else {
                return 46;
            }
        } else {
            if ([[self.infoTableView indexPathForSelectedRow] section] == 0) {
                CGRect textRect = [self.appDelegate.configuration.currentBibContact boundingRectWithSize:CGSizeMake(556, 10000.0f)
                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                                                                 context:nil];
                return textRect.size.height + 80;
            } else if ([[self.infoTableView indexPathForSelectedRow] section] == 2) {
                id currentObject = [self.appDelegate.configuration.currentBibImprint objectForKey:[self.appDelegate.configuration.currentBibImprintTitles objectAtIndex:indexPath.row]];
                CGRect textRect = [(NSString *)currentObject boundingRectWithSize:CGSizeMake(556, 10000.0f)
                                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}
                                                                          context:nil];
                return textRect.size.height + 40;
            } else {
                return 46;
            }
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

- (BOOL)shouldAutorotate
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    } else {
        return NO;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentSelectedIndexPath = [tableView indexPathForSelectedRow];
    if (currentSelectedIndexPath != nil)
    {
        if (tableView.tag == 0) {
            [[tableView cellForRowAtIndexPath:currentSelectedIndexPath] setBackgroundColor:[UIColor clearColor]];
            [[tableView cellForRowAtIndexPath:currentSelectedIndexPath].textLabel setTextColor:[UIColor blackColor]];
        }
    }
    
    return indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 0) {
        if (cell.isSelected == YES)
        {
            [cell setBackgroundColor:self.appDelegate.configuration.currentBibTintColor];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
        else
        {
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell.textLabel setTextColor:[UIColor blackColor]];
        }
    }
}

- (UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)commandIsNotInScope:(NSString *)command {
   self.contentTableView.tableFooterView = nil;
}

- (void)networkIsNotReachable:(NSString *)command {
   [self commandIsNotInScope:command];
}

@end
