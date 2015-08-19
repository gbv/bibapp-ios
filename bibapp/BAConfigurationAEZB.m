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
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-18-64", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://aezb.api.effective-webwork.de", @"Standard-Katalog", nil]];
   self.currentBibFeedURL = @"http://www.uke.de/aerztliche-zentralbibliothek";
   [self.currentBibFeedURLs addObject:[[NSArray alloc] initWithObjects:@"http://www.uke.de/aerztliche-zentralbibliothek", @"Standard-Katalog", nil]];
   self.currentBibTintColor = [UIColor colorWithRed:0 green:0.18 blue:0.475 alpha:1];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Universitätsklinikum Hamburg-Eppendorf (UKE)\n\nMartinistraße 52\n20246 Hamburg\nTelefon:  +49 (0)40 74 10 - 0\ninfo@uke.uni-hamburg.de\n\nDas Universitätsklinikum Hamburg-Eppendorf ist eine rechtsfähige Körperschaft des öffentlichen Rechts und eine Gliedkörperschaft der Universität Hamburg. Zuständige Aufsichtsbehörde ist die Behörde für Wissenschaft und Forschung, Hamburger Straße 37, 22083 Hamburg.\n\nVorstand:\nProf. Dr. Burkhard Göke, Ärztlicher Direktor und Vorstandsvorsitzender\nProf. Dr. Dr. Uwe Koch-Gromus, Dekan\nJoachim Prölß, Direktor für Patienten- und Pflegemanagement\nRainer Schoppik, Kaufmännischer Direktor\n\nInhaltlicher Verantwortlicher gemäß § 5 TMG und § 55 RStV:\nProf. Dr. Burkhard Göke, Ärztlicher Direktor und Vorstandsvorsitzender\n\nUmsatzsteuer-Identifikationsnummer gemäß § 27a UStG:DE 218/618/948" forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Ursprünglicher Entwurf und Konzeption: UB Lüneburg, UB Hildesheim, VZG Göttingen\n\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Ärztliche Zentralbibliothek\n\nLeihstelle: 040/7410-59552\nAuskunft: 040/7410-53012\n\nE-Mail: aezb@uke.de\n\nTäglich geöffnet von 08:00 - 22:00 Uhr\nService Mo.-Fr. von 08:00 - 17:00 Uhr";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-18-64";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-18-64", @"Standard-Katalog", nil]];
   self.currentBibSearchCountURL = @"";
   self.currentBibRequestTitle = @"kostenpflichtig (0,80€) vormerken";
   self.currentBibFeedURLIsWebsite = YES;
   self.currentBibHideDepartment = YES;
}

@end
