//
//  BAConfigurationHFMW.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationHFMWe.h"

@implementation BAConfigurationHFMWe

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-wim8", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Wim8", @"Standard-Katalog", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Wim8", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"";
    self.currentBibTintColor = [UIColor colorWithRed:0.200000F green:0.403922F blue:0.701961F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Hochschule für Musik FRANZ LISZT Weimar\nHochschulbibliothek\nPlatz der Demokratie 2/3\n99423 Weimar\nTel. +49 (0) 3643 | 555 124\nFax +49 (0) 3643 | 555 160\n\nDie Hochschule für Musik FRANZ LISZT Weimar ist eine rechtsfähige Körperschaft des öffentlichen Rechts und zugleich eine staatliche Einrichtung gemäß § 2 Absatz 1 Thüringer Hochschulgesetz.\nSie wird durch ihren Präsidenten, Herrn Prof. Dr. Christoph Stölzl, gesetzlich vertreten.\nZuständige Aufsichtsbehörde: Thüringer Ministerium für Bildung, Wissenschaft und Kultur." forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit Ihre bibliotheksspezifischen Zugangsdaten  (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“ für das jeweilige Konto. Mit dieser  Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu.\n\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Diese App wurde von der Hochschule für Musik FRANZ LISZT Weimar mit großer Sorgfalt erstellt und geprüft, dennoch können wir aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte geben. Eine Haftung der Hochschule für Musik FRANZ LISZT Weimar für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt. Die Hochschule für Musik FRANZ LISZT Weimar behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\n\nDiese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"Entwurf und Konzeption\nK. Hofmann\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Hochschule für Musik FRANZ LISZT Weimar\nHochschulbibliothek\nPlatz der Demokratie 2/3\n99423 Weimar\n\nTel. +49 (0) 3643 | 555 124\nFax +49 (0) 3643 | 555 160\nE-Mail: bibliothek@hfm-weimar.de";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Wim8";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Wim8", @"Standard-Katalog", nil]];
}

@end