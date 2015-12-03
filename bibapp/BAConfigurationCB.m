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
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter im Sinne von § 5 TMG", @"Vertretungsberechtigte", @"Präses", @"Hauptgeschäftsführer", @"Aufsichtsbehörde", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Handelskammer Hamburg\nCommerzbibliothek\nAdolphsplatz 1\n20457 Hamburg\n\nTelefon: +49 40 36138-377\nTelefax: +49 40 36138-437\nE-Mail: info@commerzbibliothek.de\n\nDie Handelskammer Hamburg ist eine Körperschaft des öffentlichen Rechts.\n\nDie Commerzbibliothek ist eine Einrichtung der Handelskammer Hamburg. Leiterin der Commerzbibliothek ist Sabine Lurtz-Herting." forKey:@"Anbieter im Sinne von § 5 TMG"];
   [self.currentBibImprint setObject:@"Gem. § 7 Abs. 2 Gesetz zur vorläufigen Regelung des Rechts der Industrie- und Handelskammern (IHKG) in Verbindung mit § 3 Abs. 1 der Satzung der Handelskammer Hamburg vertreten der Präses und der Hauptgeschäftsführer die IHK rechtsgeschäftlich und gerichtlich. Für die Geschäfte der laufenden Verwaltung ist der Hauptgeschäftsführer allein vertretungsberechtigt (§ 3 Abs. 2 Satzung der Handelskammer Hamburg)." forKey:@"Vertretungsberechtigte"];
   [self.currentBibImprint setObject:@"Fritz Horst Melsheimer\nAdolphsplatz 1\n20457 Hamburg\nTelefon +49 40 36138-138\nTelefax +49 40 36138-401\nE-Mail service@hk24.de" forKey:@"Präses"];
   [self.currentBibImprint setObject:@"Prof. Dr. Hans-Jörg Schmidt-Trenz\nAdolphsplatz 1\n20457 Hamburg\nTelefon +49 40 36138-138\nTelefax +49 40 36138-401\nE-Mail service@hk24.de\n\nUmsatzsteuer-Identifikationsnummer:\nDE 118510412" forKey:@"Hauptgeschäftsführer"];
   [self.currentBibImprint setObject:@"Zuständige Aufsichtsbehörde ist gemäß § 11 Abs. 1 IHKG in Verbindung mit Artikel 1 § 15 Abs. 1 des Hamburger Kammergesetzes die Behörde für Wirtschaft, Verkehr und Innovation.\n\nBehörde für Wirtschaft, Verkehr und Innovation\nAlter Steinweg 4 / Wexstraße 7\n20459 Hamburg\nTelefon: +49 40 42841-0\nTelefax: +49 40 42841-1620\nE-Mail: poststelle@bwa.hamburg.de" forKey:@"Aufsichtsbehörde"];
   [self.currentBibImprint setObject:@"Sie haben die Möglichkeit, Ihre bibliotheksspezischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“ für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu. Die BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"Diese App wurde von der Commerzbibliothek mit großer Sorgfalt erstellt und geprüft, dennoch können wir aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte geben. Eine Haftung der Commerzbibliothek für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen, ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt. Die Commerzbibliothek behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen. Die App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
   [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg),\nJ. Schrader (UB Hildesheim),\nJ. Voss (VZG Göttingen)\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Commerzbibliothek und Archiv\nHandelskammer Hamburg\nAdolphsplatz 1\n20457 Hamburg\n\nTel.: +49 40 36138-371\nFax: +49 40 36138-437\n\nhttp://www.hk24.de";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-205";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-205", @"Standard-Katalog", nil]];
   //self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=BD296&page=20";
}

@end
