//
//  BAConfigurationFHN.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationFHN.h"

@implementation BAConfigurationFHN

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibLocalSearchURL = @"DE-Wim2";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-wim2", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    self.currentBibDetailURL = @"http://daia.gbv.de/isil/DE-Wim2";
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Wim2", @"Standard-Katalog", nil]];
    //self.currentBibPAIAURL = @"https://paia.gbv.de/isil/DE-Hil2";
    self.currentBibPAIAURL = @"https://paia.gbv.de/DE-Hil2/";
    //[self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/isil/DE-Hil2", @"Standard-Katalog", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Hil2", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"http://www.uni-weimar.de/de/universitaet/aktuell/pinnwaende/rss/bereich/bibliothek/";
    self.currentBibTintColor = [UIColor colorWithRed:0.000000F green:0.349020F blue:0.619608F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"" forKey:@"Vertreter"];
    [self.currentBibImprint setObject:@"" forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"" forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Wim2";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Wim2", @"Standard-Katalog", nil]];
    self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=EM482&amp;page=2";
}

@end