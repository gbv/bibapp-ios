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
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Wim2/daia", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Wim2", @"Standard-Katalog", nil]];
   self.currentBibFeedURL = @"";
   self.currentBibTintColor = [[UIColor alloc] initWithRed:0.77 green:0.18 blue:0.36 alpha:1.0];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Datenschutzerklärung", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Universitätsbibliothek der Bauhaus-Universität Weimar\nSteubenstr. 6\n99423 Weimar\nTelefon: 03643/582801\nFax: 03643/582802\nE-Mail: info@ub.uni-weimar.de\nDie Bauhaus-Universität Weimar ist eine Körperschaft des öffentlichen Rechts. Sie wird durch ihren Rektor, Herrn Prof. Dr. Karl Beucke, gesetzlich vertreten. Zuständige Aufsichtsbehörde: Thüringer Ministerium für Bildung, Wissenschaft und Kultur." forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Wir erheben, verwenden und speichern Ihre personenbezogenen Daten ausschließlich im Rahmen der Bestimmungen des Bundesdatenschutzgesetzes der Bundesrepublik Deutschland. Nachfolgend unterrichten wir Sie über Art, Umfang und Zweck der Datenerhebung und Verwendung.\n\n\nSpeicherung von personenbezogenen Daten\n\nDaten zur Speicherung des Logins (zum Zwecke eines automatischen Logins ohne erneute Passworteingabe) sowie zum Vorhalten der Bestände in der persönlichen Merkliste werden ausschließlich auf dem Telefon des Benutzers gespeichert und vorgehalten.\nDer Benutzer muss der dauerhaften Speicherung seiner Login-Information aktiv zustimmen.\n\n\nÜbertragung von personenbezogenen Daten\n\nDie Übertragung persönlicher Daten erfolgt nur zum Zweck der Authentifizierung. Darüber hinaus werden weder Informationen zur Authentifizierung noch zur Merkliste an Dritte weitergegeben. Die Übertragung dieser Informationen sowie sonstige Kommunikation mit der VZG erfolgt verschlüsselt.\n\n\nDie Kommunikation, basiert auf HTTPS (Hypertext Transfer Protocol Secure), dem allgemein üblichen Standard zur sicheren Übertragung im Web. Grundlage des HTTPS-Standards sind die Identifikation und Authentifizierung der Kommunikationspartner sowie die verschlüsselte Übertragung der Nutzerdaten.\n\n\nDer Lokalisierungsdienst ermöglicht bei Anfragen an den GVK-Katalog die Sortierung der Ergebnisliste nach der Entfernung zum Standort. Ein Abschalten des Lokalisierungsdienstes in den Systemeinstellungen beeinträchtig nicht den Funktionsumfang." forKey:@"Datenschutzerklärung"];
   [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg),\nJ. Schrader (UB Hildesheim),\nJ. Voss (VZG Göttingen)\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Kontakt\nDirektor der Bibliothek, Dr. Frank Simon-Ritz,\nTelefon: 0 36 43 / 58 28 00\nE-Mail: sekretariat@ub.uni-weimar.de\n\nAusleihe:\nTel.: 0 36 43 / 58 28 10\nausleihe@ub.uni-weimar.de\n\nInformation\nTel.: 0 36 43 / 58 28 20\nE-Mail: info@ub.uni-weimar.de\n\nFernleihe:\nTel.: 0 36 43 / 58 28 12 oder 0 36 43 / 58 28 09\nfernleihe@ub.uni-weimar.de\n\nBibliothek Baustoffe und Naturwissenschaften:\nTel.: 0 36 43 / 58 28 90";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Wim2";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Wim2", @"Standard-Katalog", nil]];
   [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"https://piwik.uni-weimar.de/piwik.php?idsite=25&rec=1", @"Standard-Katalog", nil]];
}

@end
