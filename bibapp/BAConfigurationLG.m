//
//  BAConfigurationLG.m
//  bibapp
//
//  Created by Johannes Schultze on 20.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationLG.h"

@implementation BAConfigurationLG

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-luen4", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Luen4", @"Standard-Katalog", nil]];
    //[self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/isil/DE-Luen4", @"Standard-Katalog", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Luen4", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"http://www.leuphana.de/bibliothek/aktuell.html?type=777";
    self.currentBibTintColor = [[UIColor alloc] initWithRed:0.56 green:0.3 blue:0.32 alpha:1.0];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Universitätsbibliothek Lüneburg\nScharnhorststr. 1\n21335 Lüneburg\n\nE-Mail: unibib@uni.leuphana.de\nTelefon: +49 (0) 4131 - 677 1100\nTelefax: +49 (0) 4131 - 677 1111" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Die Universitätsbibliothek Lüneburg ist eine Einrichtung der Leuphana Universität Lüneburg, sie wird vertreten durch ihren Leiter, Torsten Ahlers.\nDie Leuphana Universität ist eine Körperschaft des öffentlichen Rechts in der Trägerschaft einer Stiftung öffentlichen Rechts. Sie wird durch den Präsidenten Sascha Spoun gesetzlich vertreten.\nUmsatzsteuer-Identifikationsnummer gemäß § 27a Umsatzsteuergesetz: DE 811 305 548 " forKey:@"Vertreter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“  für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu.\n\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Diese App wurde von der Leuphana Universität Lüneburg mit großer Sorgfalt  erstellt und geprüft, dennoch können wir aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte geben. Eine Haftung der Leuphana Universität Lüneburg für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt.  Die Leuphana Universität Lüneburg behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\n\nDiese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg),\nJ. Schrader (UB Hildesheim),\nJ. Voss (VZG Göttingen)\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Universitätsbibliothek Lüneburg\nScharnhorststraße 1\n21335 Lüneburg\n\nTelefon: (04131) 677-1100\nTelefax: (04131) 677-1111\n\nE-mail: unibib@uni-lueneburg.de\nWWW: www.leuphana.de/ub";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Luen4";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Luen4", @"Standard-Katalog", nil]];
    //self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=BD296&page=20";
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"http://dbspixel.hbz-nrw.de/count?id=BD296&page=20", @"Standard-Katalog", nil]];
}

@end
