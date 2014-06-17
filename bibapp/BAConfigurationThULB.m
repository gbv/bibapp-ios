//
//  BAConfigurationThULB.m
//  bibapp
//
//  Created by Johannes Schultze on 24.04.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationThULB.h"

@implementation BAConfigurationThULB

- (void)initConfiguration
{
   self.currentBibSearchMaximumRecords = @"20";
   self.currentBibLocalSearchURL = @"opac-de-27";
   [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-27", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
   self.currentBibDetailURL = @"http://daia.gbv.de/isil/DE-27";
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-27", @"Standard-Katalog", nil]];
   self.currentBibPAIAURL = @"https://jenopc5.thulb.uni-jena.de:7242";
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://jenopc5.thulb.uni-jena.de:7242", @"Standard-Katalog", nil]];
   //self.currentBibFeedURL = @"http://www.thulb.uni-jena.de";
   self.currentBibTintColor = [UIColor colorWithRed:0.337255F green:0.556863F blue:0.745098F alpha:1.0F];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Thüringer Universitäts- und Landesbibliothek Jena Bibliotheksplatz 2\n07743 Jena\n\nE-Mail: thulb_direktion@thulb.uni-jena.de\n\nTel.: +49 3641 9-40000\nFax: +49 3641 9-40002\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"" forKey:@"Vertreter"];
   [self.currentBibImprint setObject:@"" forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"" forKey:@"Rechtliche Hinweise zur Haftung"];
   [self.currentBibImprint setObject:@"" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Anschrift\nThüringer Universitäts- und Landesbibliothek Jena Postfach\n07743 Jena\nhttp://www.thulb.uni-jena.de\n\nAuskunft\nTelefon: +49 3641 9-40100\nE-Mail: info@thulb.uni-jena.de\n\nAusleihe\nTelefon: +49 3641 9-40110\nE-Mail: thulb_ausleihe@thulb.uni-jena.de";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-27";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-27", @"Standard-Katalog", nil]];
   //self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=AN087&page=3";
}

@end
