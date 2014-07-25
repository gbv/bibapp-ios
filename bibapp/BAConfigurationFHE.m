//
//  BAConfigurationFHE.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationFHE.h"

@implementation BAConfigurationFHE

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibLocalSearchURL = @"DE-546";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-546", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    self.currentBibDetailURL = @"http://daia.gbv.de/isil/DE-546";
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-546", @"Standard-Katalog", nil]];
    self.currentBibPAIAURL = @"https://opac.uni-erfurt.de/DE-546/";
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://opac.uni-erfurt.de/DE-546", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"http://www.fh-erfurt.de/fhe/?id=663&type=100&tx_ttnews[cat]=2";
    self.currentBibTintColor = [UIColor colorWithRed:0.000000F green:0.200000F blue:0.400000F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", nil];
    [self.currentBibImprint setObject:@"Fachhochschule Erfurt\nBibliothek\nAltonaer Straße 25\n99085 Erfurt\n\nTel.: 0361 6700-519\nFax: 0361 6700-518\n\nDie Fachhochschule Erfurt ist eine Körperschaft des öffentlichen Rechts.\nSie wird durch den Leiter der Hochschule Prof. Dr.-Ing. Volker Zerbe gesetzlich vertreten.\nUSt-Id-Nr: DE 241 446 583\n\nZuständige Aufsichtsbehörde:\nThüringer Ministerium für Bildung, Wissenschaft und Kultur\nWerner-Seelenbinder Straße 7\n99096 Erfurt\n\nTechnische Betreuung:\nHochschulbibliothek der FHE\nAltonaer Straße 25\n99085 Erfurt" forKey:@"Anbieter"];
    self.currentBibContact = @"Altonaer Straße 25\n99085 Erfurt\n\nAusleihtheke:\nTel.: 0361 6700-519\nFax: 0361 6700-518\n\nE-Mail: bibliothek@fh-erfurt.de ";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-546";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-546", @"Standard-Katalog", nil]];
    self.currentBibSearchCountURL = @"";
}

@end