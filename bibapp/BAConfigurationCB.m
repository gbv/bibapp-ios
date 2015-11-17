//
//  BAConfigurationCB.m
//  bibapp
//
//  Created by Johannes Schultze on 17.11.15.
//  Copyright © 2015 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationCB.h"

@implementation BAConfigurationCB

- (void)initConfiguration
{
   self.currentBibSearchMaximumRecords = @"20";
   [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-205", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-205", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/de-205", @"Standard-Katalog", nil]];
   //self.currentBibFeedURL = @"";
   self.currentBibTintColor = [[UIColor alloc] initWithRed:0.00 green:0.29 blue:0.52  alpha:1.0];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Text folgt ..." forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Text folgt ..." forKey:@"Vertreter"];
   [self.currentBibImprint setObject:@"Text folgt ..." forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"Text folgt ..." forKey:@"Rechtliche Hinweise zur Haftung"];
   [self.currentBibImprint setObject:@"Text folgt ..." forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Commerzbibliothek und Archiv\nHandelskammer Hamburg\nAdolphsplatz 1\n20457 Hamburg\n\nTel.: +49 40 36138-371\nFax: +49 40 36138-437\n\nhttp://www.hk24.de";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-205";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-205", @"Standard-Katalog", nil]];
   //self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=BD296&page=20";
}

@end
