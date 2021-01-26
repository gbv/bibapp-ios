//
//  BAConfigurationUBE.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationUFB.h"

@implementation BAConfigurationUFB

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibStandardCatalogue = @"UFB Erfurt/Gotha";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-1876", @"UFB Erfurt/Gotha", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-547", @"UB Erfurt", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-39", @"FB Gotha", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://opac.uni-erfurt.de/DE-547/daia", @"UFB Erfurt/Gotha", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://opac.uni-erfurt.de/DE-547/daia", @"UB Erfurt", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://opac.uni-erfurt.de/DE-547/daia", @"FB Gotha", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://opac.uni-erfurt.de/DE-547", @"UFB Erfurt/Gotha", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://opac.uni-erfurt.de/DE-547", @"UB Erfurt", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://opac.uni-erfurt.de/DE-547", @"FB Gotha", nil]];
    self.currentBibFeedURL = @"";
    self.currentBibTintColor = [UIColor colorWithRed:0.050980F green:0.188235F blue:0.274510F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", nil];
    [self.currentBibImprint setObject:@"Universitäts- und Forschungsbibliothek Erfurt/Gotha\nNordhäuser Straße 63\n99089 Erfurt\nTelefon: +49 361 737-5800\nFax: +49 361 737-5849\nE-Mail: information.ub(at)uni-erfurt.de\n\nDie Universität Erfurt ist eine Körperschaft des öffentlichen Rechts.\nSie wird durch Prof. Dr. Kai Brodersen, den Präsidenten der Universität Erfurt, gesetzlich vertreten.\nUSt-Id-Nr: DE 811 627 407\nZuständige Aufsichtsbehörde\nMinisterium für Bildung, Wissenschaft und Kultur\nWerner-Seelenbinder Straße 7\n99096 Erfurt\n\nVerantwortlich für den Inhalt nach § 55 Abs. 2 RStV\nBibliotheksdirektor (komm.) Dr. Eckart Gerstner\n+49 361 737-5500\n+49 361 737-5509\neckart.gerstner(at)uni-erfurt.de" forKey:@"Anbieter"];
    self.currentBibContact = @"UB Erfurt\nE-Mail: information.ub@uni-erfurt.de\nTelefon: 0361/737-5800\n\nFB Gotha\nE-Mail: bibliothek.gotha@uni-erfurt.de\n\nTelefon: 0361/737-5540";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-1876";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-1876", @"UFB Erfurt/Gotha", nil]];
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-547", @"UB Erfurt", nil]];
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-39", @"FB Gotha", nil]];
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"http://dbspixel.hbz-nrw.de/count?id_EX461&amp;page=20", @"UFB Erfurt/Gotha", nil]];
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"http://dbspixel.hbz-nrw.de/count?id_EX461&amp;page=20", @"UB Erfurt", nil]];
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"http://dbspixel.hbz-nrw.de/count?id_EX461&amp;page=20", @"FB Gotha", nil]];
}

@end
