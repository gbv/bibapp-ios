//
//  BAConfigurationAEZB.m
//  bibapp
//
//  Created by Johannes Schultze on 17.02.15.
//  Copyright (c) 2015 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationAEZB.h"

@implementation BAConfigurationAEZB

- (void)initConfiguration
{
   self.currentBibSearchMaximumRecords = @"20";
   [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-18-64", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-18", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://aezb.api.effective-webwork.de", @"Standard-Katalog", nil]];
   self.currentBibFeedURL = @"";
   self.currentBibTintColor = [[UIColor alloc] initWithRed:0.74 green:0.11 blue:0.23 alpha:1.0];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"" forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"" forKey:@"Vertreter"];
   [self.currentBibImprint setObject:@"" forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"" forKey:@"Rechtliche Hinweise zur Haftung"];
   [self.currentBibImprint setObject:@"Ursprünglicher Entwurf und Konzeption: UB Lüneburg, UB Hildesheim, VZG Göttingen\n\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-18-64";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-18-64", @"Standard-Katalog", nil]];
   self.currentBibSearchCountURL = @"";
   self.currentBibRequestTitle = @"kostenpflichtig (0,80€) vormerken";
}

@end
