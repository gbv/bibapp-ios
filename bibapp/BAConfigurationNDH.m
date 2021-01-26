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
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-564", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-564/daia", @"Standard-Katalog", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-564", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"";
    self.currentBibTintColor = [UIColor colorWithRed:0.000000F green:0.349020F blue:0.619608F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", nil];
    [self.currentBibImprint setObject:@"Hochschulbibliothek Nordhausen\nWeinberghof 4\n99734 Nordhausen\n\nhttp://www.hs-nordhausen.de/service/bibliothek/\nE-Mail: bibliothek@hs-nordhausen.de\nTel.: 03631 420-184\nFax: 03631 420-815\n\nImpressum der Hochschule:\nhttp://www.hs-nordhausen.de/allgemeines/impressum/?T=0" forKey:@"Anbieter"];
    self.currentBibContact = @"Hochschule Nordhausen\nHochschulbibliothek\nWeinberghof 4\n99734 Nordhausen\n\nTel. Information: 03631 420-184\nTel. Ausleihe: 03631 420-185\nFax: 03631 420-815\nE-Mail: bibliothek@hs-nordhausen.de";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-564";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-564", @"Standard-Katalog", nil]];
    self.pushServiceGoogleServiceFile = @"GoogleService-Info";
}

@end
