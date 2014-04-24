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
   //self.currentBibPAIAURL = @"https://paia.gbv.de/isil/DE-Hil2";
   self.currentBibPAIAURL = @"https://paia.gbv.de/DE-27/";
   //[self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/isil/DE-Hil2", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-27", @"Standard-Katalog", nil]];
   //self.currentBibFeedURL = @"http://www.thulb.uni-jena.de";
   self.currentBibTintColor = [UIColor colorWithRed:0.337255F green:0.556863F blue:0.745098F alpha:1.0F];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Universitätsbibliothek Hildesheim\n\nMarienburger Platz 22\n31141 Hildesheim\n\nE-Mail: auskunft@uni-hildesheim.de\n\nTelefon: +49 (0) 51 21 - 883 260\nTelefax: +49 (0) 51 21 - 883 266" forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Die Universitätsbibliothek Hildesheim ist eine Einrichtung der Stiftung Universität Hildesheim, sie wird vertreten durch ihren Leiter, Dr. Ewald Brahms. Die Stiftung Universität Hildesheim ist eine rechtsfähige Stiftung öffentlichen Rechts. Die Stiftung unterhält und fördert die Universität Hildesheim in deren Eigenschaft als Körperschaft des öffentlichen Rechts und übt die Rechtsaufsicht über sie aus. Stiftung Universität Hildesheim und Universität Hildesheim werden vertreten durch ihren Präsidenten Herrn Prof. Dr. Wolfgang-Uwe Friedrich.\n\nUmsatzsteuer-Identifikationsnummer gemäß § 27 a Umsatzsteuergesetz: DE 239259506." forKey:@"Vertreter"];
   [self.currentBibImprint setObject:@"Sie haben die Möglichkeit Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“  für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu.\n\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"Diese App wurde von der Universitätsbibliothek Hildesheim mit großer Sorgfalt  erstellt und geprüft, dennoch können wir aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte geben. Eine Haftung der Universitätsbibliothek Hildesheim für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt.  Die Universitätsbibliothek Hildesheim behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\n\nDiese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
   [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg),\nJ. Schrader (UB Hildesheim),\nJ. Voss (VZG Göttingen)\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Anschrift\nUniversitätsbibliothek Hildesheim\nMarienburger Platz 22\n31141 Hildesheim\n\nwww.uni-hildesheim.de/bibliothek\n\nAuskunft\nTelefon: (05121) 883-260\nE-Mail: auskunft@uni-hildesheim.de\n\nAusleihe\nTelefon: (05121) 883-264\nE-Mail: ausleihe@uni-hildesheim.de";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-27";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-27", @"Standard-Katalog", nil]];
   //self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=AN087&page=3";
}

@end
