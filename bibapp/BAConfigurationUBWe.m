//
//  BAConfigurationBUW.m
//  bibapp
//
//  Created by Johannes Schultze on 19.05.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationUBWe.h"

@implementation BAConfigurationUBWe

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
   self.currentBibTintColor = [[UIColor alloc] initWithRed:0.77 green:0.18 blue:0.36 alpha:1.0];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Universitätsbibliothek der Bauhaus-Universität Weimar\nSteubenstr. 6\n99423 Weimar\nTelefon: 03643/582801\nFax: 03643/582802\nE-Mail: info@ub.uni-weimar.de\nDie Bauhaus-Universität Weimar ist eine Körperschaft des öffentlichen Rechts. Sie wird durch ihren Rektor, Herrn Prof. Dr. Karl Beucke, gesetzlich vertreten. Zuständige Aufsichtsbehörde: Thüringer Ministerium für Bildung, Wissenschaft und Kultur." forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg),\nJ. Schrader (UB Hildesheim),\nJ. Voss (VZG Göttingen)\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Fragen an die Bibliothek:\nTelefon: 03643/582801\nE-Mail: info@ub.uni-weimar.de";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Wim2";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Wim2", @"Standard-Katalog", nil]];
   self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=EM482&amp;page=2";
}

@end