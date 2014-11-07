//
//  BAConfigurationTUBS.m
//  bibapp
//
//  Created by Johannes Schultze on 07.11.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationTUBS.h"

@implementation BAConfigurationTUBS

- (void)initConfiguration
{
   self.currentBibSearchMaximumRecords = @"20";
   self.currentBibLocalSearchURL = @"opac-de-84";
   [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-84", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
   self.currentBibDetailURL = @"http://daia.gbv.de/isil/DE-84";
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-84", @"Standard-Katalog", nil]];
   self.currentBibPAIAURL = @"https://paia.gbv.de/DE-84";
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-84", @"Standard-Katalog", nil]];
   self.currentBibFeedURL = @"";
   self.currentBibTintColor = [[UIColor alloc] initWithRed:0.85 green:0.2 blue:0.32 alpha:1.0];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Erhebung von Nutzungsdaten", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"" forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"" forKey:@"Vertreter"];
   [self.currentBibImprint setObject:@"" forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"" forKey:@"Rechtliche Hinweise zur Haftung"];
   [self.currentBibImprint setObject:@"" forKey:@"Erhebung von Nutzungsdaten"];
   [self.currentBibImprint setObject:@"" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-84";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-84", @"Standard-Katalog", nil]];
   self.currentBibSearchCountURL = @"";
}


@end
