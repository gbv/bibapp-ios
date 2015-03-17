//
//  BAConfigurationTUBS.m
//  bibapp
//
//  Created by Johannes Schultze on 07.11.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationTUBS.h"

@implementation BAConfigurationTUBS

- (void)initConfiguration
{
   self.currentBibSearchMaximumRecords = @"20";
   [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-84", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-84", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-84", @"Standard-Katalog", nil]];
   self.currentBibFeedURL = @"";
   self.currentBibTintColor = [[UIColor alloc] initWithRed:0.74 green:0.11 blue:0.23 alpha:1.0];   
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Universitätsbibliothek Braunschweig\nPockelsstr. 13\n38106 Braunschweig\nE-Mail: ub@tu-braunschweig.de\nTelefon: +49 (0)531 - 391 5011" forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Die Universitätsbibliothek Braunschweig ist eine Einrichtung der Technischen Universität Braunschweig. Sie wird vertreten durch ihre Direktorin Katrin Stump M.A.\n\nDie Technische Universität Braunschweig ist eine Körperschaft des öffentlichen Rechts. Sie wird durch ihren Präsidenten Herrn Prof. Dr.-Ing. Dr. h. c. Jürgen Hesselbach vertreten.\n\nUmsatzsteuer-Identifikationsnummer gemäß § 27 a Umsatzsteuergesetz: DE 152330858." forKey:@"Vertreter"];
   [self.currentBibImprint setObject:@"Sie haben die Möglichkeit, Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter \"Optionen\" den Punkt \"Zugangsdaten speichern\" für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu. Die BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"Diese App wurde von der Universitätsbibliothek Braunschweig mit großer Sorgfalt  erstellt und  geprüft, dennoch können wir aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte geben. Eine Haftung der Universitätsbibliothek Braunschweig für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt.  Die Universitätsbibliothek Braunschweig behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen. Diese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
   [self.currentBibImprint setObject:@"Ursprünglicher Entwurf und Konzeption: UB Lüneburg, UB Hildesheim, VZG Göttingen\n\nAnpassung: UB Braunschweig\n\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Universitätsbibliothek Braunschweig\n\nAnschrift\nUniversitätsbibliothek Braunschweig\nPockelsstraße 13\n38106 Braunschweig\n\nwww.biblio.tu-braunschweig.de\n\nAusleihe\nTelefon: (0531)391-5017\nE-Mail: ub-leihstelle@tu-braunschweig.de\n\n\nInformation\nTelefon: (0531)391-5018\nE-Mail: ub@tu-braunschweig.de\n\nGeschäftszimmer:\nTelefon: (0531)391-5011\nE-Mail: ub@tu-braunschweig.de";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-84";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-84", @"Standard-Katalog", nil]];
   self.currentBibSearchCountURL = @"";
}

@end
