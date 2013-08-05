//
//  BAConfigurationBLS.m
//  bibapp
//
//  Created by Johannes Schultze on 01.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationBLS.h"

@implementation BAConfigurationBLS

- (void)initConfiguration
{
    self.searchTitle = @"Recherche";
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibLocalSearchURL = @"opac-de-h360";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-h360", @"Standard-Katalog", @"OPAC", nil]];
    self.currentBibDetailURL = @"http://daia.gbv.de/isil/DE-H360";
    self.currentBibPAIAURL = @"https://paia.gbv.de/isil/DE-H360";
    self.currentBibFeedURL = @"";
    self.currentBibTintColor = [[UIColor alloc] initWithRed:0.62 green:0.12 blue:0.19 alpha:1.0];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Bibliothek der Bucerius Law School\n\nJungiusstrasse 6\n\n20355 Hamburg\n\nMAIL: martin.vorberg@law-school.de\n\nMOBIL: 0176 7066 3447\n\nPHONE: 49-(0)40-30706-134 " forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Die Bibliothek der Bucerius Law School ist das Zentrum der juristischen Informationen unserer Hochschule, sie wird verantwortlich geleitet durch Herrn Martin Vorberg. Die Bucerius Law School gGmbH ist die erste private Hochschule für Rechtswissenschaft in Deutschland, sie wird verantwortlich geleitet durch Herrn Dr. Hariolf Wenzler. Die Umsatzsteuer-Identifikationsnummer gemäß § 27a Umsatzsteuergesetz:  DE 212998891." forKey:@"Vertreter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“  für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu.\n\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Diese App wurde von der Bucerius Law School gGmbH mit großer Sorgfalt  erstellt und geprüft, dennoch können wir aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte geben. Eine Haftung der Bucerius Law School gGmbH für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt.  Die Bucerius Law School gGmbH behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\n\nDiese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg),\nJ. Schrader (UB Hildesheim),\nJ. Voss (VZG Göttingen)\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Bibliothek der Bucerius Law School\n\nJungiusstrasse 6\n\n20355 Hamburg\n\nPHONE: 040 30706 134\n\nMOBIL: 0176 7066 3447\n\nMAIL: martin.vorberg@law-school.de\n\nURL: www.law-school.de/bibliothek.html";
    self.currentBibLocationUri = @"http://uri.gbv.de/organization/isil/DE-H360";
    self.currentBibSearchCountURL = @"";
}

@end
