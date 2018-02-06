//
//  BAConfigurationIAI.m
//  BibApp LG
//
//  Created by Johannes Schultze on 06.02.18.
//  Copyright © 2018 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationIAI.h"

@implementation BAConfigurationIAI

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-204", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-204/daia", @"Standard-Katalog", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-204", @"Standard-Katalog", nil]];
    self.currentBibTintColor = [UIColor colorWithRed:0.36 green:0.49 blue:0.73 alpha:1.00];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Umsatzsteueridentifikationsnummer", @"Presserechtliche Verantwortlichkeit", @"Datenschutzerklärung", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Anbieter dieser App ist im Rechtssinne das Ibero-Amerikanische Institut Preußischer Kulturbesitz.\n\nIbero-Amerikanisches Institut Preußischer Kulturbesitz\nPotsdamer Str. 37\nD-10785 Berlin\n\nTel. +49 30 266 45 1500\n\nURL: www.iai.spk-berlin.de\nE-Mail: iai@iai.spk-berlin.de" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Das IAI wird gesetzlich vertreten durch seine Direktorin." forKey:@"Vertreter"];
    [self.currentBibImprint setObject:@"Die Umsatzsteueridentifikationsnummer des IAI lautet: DE 81 1176 992" forKey:@"Umsatzsteueridentifikationsnummer"];
    [self.currentBibImprint setObject:@"Die Direktorin des Ibero-Amerikanischen Instituts: Dr. Barbara Göbel" forKey:@"Presserechtliche Verantwortlichkeit"];
    [self.currentBibImprint setObject:@"" forKey:@"Datenschutzerklärung"];
    [self.currentBibImprint setObject:@"" forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"Ursprünglich: UB Lüneburg, UB Hildesheim, VZG\nAnpassung: Ibero-Amerikanische Institut Preußischer Kulturbesitz\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Referat Benutzung - Leitung Dr. Ulrike Mühlschlegel\nE-Mail: muehlschlegel@iai.spk-berlin.de\n\nInformation / Auskunft\nTel.: +49 30 266 45 2210\nE-Mail: info@iai.spk-berlin.de\n\nAusleihe\nTel.: +49 30 266 45 2220";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-204", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"";
}

@end
