//
//  BAConfigurationDHGE.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationDHGE.h"

@implementation BAConfigurationDHGE

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibStandardCatalogue = @"Gera";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-ga20", @"Gera", @"Gera", @"Lokale Suche", nil]];
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-ei6", @"Eisenach", @"Eisenach", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.thulb.uni-jena.de/DE-Ga20/daia", @"Gera", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.thulb.uni-jena.de/DE-Ei6/daia", @"Eisenach", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.thulb.uni-jena.de/DE-Ga20", @"Gera", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.thulb.uni-jena.de/DE-Ei6", @"Eisenach", nil]];
    self.currentBibFeedURL = @"http://bibliothek-gera.dhge.de";
    [self.currentBibFeedURLs addObject:[[NSArray alloc] initWithObjects:@"http://bibliothek-gera.dhge.de", @"Gera", nil]];
    [self.currentBibFeedURLs addObject:[[NSArray alloc] initWithObjects:@"http://bibliothek-eisenach.dhge.de", @"Eisenach", nil]];
    self.currentBibTintColor = [UIColor colorWithRed:0.549020F green:0.694118F blue:0.062745F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil]; // Vertreter?
    [self.currentBibImprint setObject:@"Duale Hochschule Gera-Eisenach\nWeg der Freundschaft 4\n07546 Gera\nTel.: +49 365 / 4341-0\nFax: +49 365 / 4341-103\nE-Mail: info@dhge.de\nInternet: http://www.dhge.de\n\nDie Duale Hochschule Gera-Eisenach ist eine rechtsfähige Körperschaft des öffentlichen Rechts. Sie wird gesetzlich vertreten durch den Präsidenten der Dualen Hochschule Gera-Eisenach Prof. Dr. rer. pol. habil. Burkhard Utecht.\n\nZuständige Behörde für die Rechts- und Fachaufsicht:\nThüringer Ministerium für Wirtschaft, Wissenschaft und Digitale Gesellschaft\nMax-Reger-Straße 4-8\n99096 Erfurt" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“ für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu.\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Die BibApp wurde mit größter Sorgfalt erstellt und geprüft. Dennoch kann auf Grund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte gegeben werden. Eine Haftung der Dualen Hochschule Gera-Eisenach für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen. Die DHGE behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen. Diese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"Ursprünglich: UB Lüneburg, UB Hildesheim, VZG\nAnpassung: Duale Hochschule Gera-Eisenach\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Gera\nDuale Hochschule Gera-Eisenach\nBibliothek – Campus Gera\nWeg der Freundschaft 4\n07546 Gera\nTel.: +49 365 / 4341-118 und -119\nE-Mail: bibliothek-gera@dhge.de\nInternet: http://bibliothek-gera.dhge.de\n\nEisenach\nDuale Hochschule Gera-Eisenach\nBibliothek – Campus Eisenach\nAm Wartenberg 2\n99817 Eisenach\nTel.: +49 3691 / 6294-72 und -12\nE-Mail: bibliothek-eisenach@dhge.de\nInternet: http://bibliothek-eisenach.dhge.de";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Wim2";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Ga20", @"Gera", nil]];
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Ei6", @"Eisenach", nil]];
    self.currentBibFeedURLIsWebsite = YES;
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"http://pwk.thulb.uni-jena.de/piwik.php?idsite=4&rec=1", @"Gera", nil]];
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"http://pwk.thulb.uni-jena.de/piwik.php?idsite=5&rec=1", @"Eisenach", nil]];
    self.pushServiceGoogleServiceFile = @"GoogleService-Info";
}

@end
