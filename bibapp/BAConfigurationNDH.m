//
//  BAConfigurationFHN.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationNDH.h"

@implementation BAConfigurationNDH

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibLocalSearchURL = @"DE-564";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-564", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    self.currentBibDetailURL = @"http://daia.gbv.de/isil/DE-564";
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-564", @"Standard-Katalog", nil]];
    self.currentBibPAIAURL = @"https://opac.uni-erfurt.de/DE-564/";
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://opac.uni-erfurt.de/DE-564", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"";
    self.currentBibTintColor = [UIColor colorWithRed:0.000000F green:0.349020F blue:0.619608F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", nil];
    [self.currentBibImprint setObject:@"Fachhochschulbibliothek Nordhausen\nWeinberghof 4\n99734 Nordhausen\n\nhttp://www.fh-nordhausen.de/bibliothek.html\nE-Mail: bibliothek@fh-nordhausen.de\nTel.: 03631 420-184\nFax: 03631 420-815" forKey:@"Anbieter"];
    self.currentBibContact = @"Fachhochschule Nordhausen\nHochschulbibliothek\nWeinberghof 4\n99734 Nordhausen\n\nTel. Information: 03631 420-184\nTel. Ausleihe: 03631 420-185\nFax: 03631 420-815\nE-Mail: bibliothek@fh-nordhausen.de";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-564";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-564", @"Standard-Katalog", nil]];
    self.currentBibSearchCountURL = @"";
}

@end