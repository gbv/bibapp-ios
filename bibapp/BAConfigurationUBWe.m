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
   [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-wim2", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Wim2", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Wim2", @"Standard-Katalog", nil]];
   //self.currentBibFeedURL = @"http://www.uni-weimar.de/de/universitaet/aktuell/pinnwaende/rss/bereich/bibliothek/";
   self.currentBibFeedURL = @"";
   self.currentBibTintColor = [[UIColor alloc] initWithRed:0.77 green:0.18 blue:0.36 alpha:1.0];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Universitätsbibliothek der Bauhaus-Universität Weimar\nSteubenstr. 6\n99423 Weimar\nTelefon: 03643/582801\nFax: 03643/582802\nE-Mail: info@ub.uni-weimar.de\nDie Bauhaus-Universität Weimar ist eine Körperschaft des öffentlichen Rechts. Sie wird durch ihren Rektor, Herrn Prof. Dr. Karl Beucke, gesetzlich vertreten. Zuständige Aufsichtsbehörde: Thüringer Ministerium für Bildung, Wissenschaft und Kultur." forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg),\nJ. Schrader (UB Hildesheim),\nJ. Voss (VZG Göttingen)\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Kontakt\nDirektor der Bibliothek, Dr. Frank Simon-Ritz,\nTelefon: 0 36 43 / 58 28 00\nE-Mail: sekretariat@ub.uni-weimar.de\n\nAusleihe:\nTel.: 0 36 43 / 58 28 10\nausleihe@ub.uni-weimar.de\n\nInformation\nTel.: 0 36 43 / 58 28 20\nE-Mail: info@ub.uni-weimar.de\n\nFernleihe:\nTel.: 0 36 43 / 58 28 12 oder 0 36 43 / 58 28 09\nfernleihe@ub.uni-weimar.de\n\nBibliothek Baustoffe und Naturwissenschaften:\nTel.: 0 36 43 / 58 28 90";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Wim2";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Wim2", @"Standard-Katalog", nil]];
   self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=EM482&amp;page=20";
}

@end