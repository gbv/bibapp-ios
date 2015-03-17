//
//  BAConfigurationBAT.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationBAT.h"

@implementation BAConfigurationBAT

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibStandardCatalogue = @"BA Gera";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-ga20", @"BA Gera", @"BA Gera", @"Lokale Suche", nil]];
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-ei6", @"BA Eisenach", @"BA Eisenach", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Ga20", @"BA Gera", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Ei6", @"BA Eisenach", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://jenopc5.thulb.uni-jena.de:7242/DE-Ga20", @"BA Gera", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://jenopc5.thulb.uni-jena.de:7242/DE-Ei6", @"BA Eisenach", nil]];
    self.currentBibFeedURL = @"http://www.ba-gera.de";
    [self.currentBibFeedURLs addObject:[[NSArray alloc] initWithObjects:@"http://www.ba-gera.de", @"BA Gera", nil]];
    [self.currentBibFeedURLs addObject:[[NSArray alloc] initWithObjects:@"http://www.ba-eisenach.de", @"BA Eisenach", nil]];
    self.currentBibTintColor = [UIColor colorWithRed:0.549020F green:0.694118F blue:0.062745F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil]; // Vertreter?
    [self.currentBibImprint setObject:@"Staatliche Studienakademie Thüringen\nBerufsakademien Gera und Eisenach\nDirektor Prof. Dr. rer. pol. habil. Burkhard Utecht\nWeg der Freundschaft 4A\n07546 Gera\nTel.: +49 365 / 4341-0\nFax: +49 365 / 4341-103\nE-Mail: info@ba-gera.de\nInternet: http://www.ba-gera.de\nDie Staatliche Studienakademie Thüringen ist eine rechtsfähige Körperschaft des öffentlichen Rechts.\nZuständige Behörde für die Rechts- und Fachaufsicht\nThüringer Ministerium für Bildung, Wissenschaft und Kultur\nPostfach 900463\n99107 Erfurt\nTel.: +49 361 / 37 9-00\nFax: +49 361 / 37 94 690\nE-Mail: poststelle@tmbwk.thueringen.de" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“ für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu.\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Die BibApp wurde mit größter Sorgfalt erstellt und geprüft. Dennoch kann auf Grund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte gegeben werden. Eine Haftung der Staatlichen Studienakademie Thüringen für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen. Die Staatliche Studienakademie behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen. Diese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"Ursprünglich: UB Lüneburg, UB Hildesheim, VZG\nAnpassung: Staatliche Studienakademie Thüringen\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Gera\nBibliothek der Berufsakademie Gera\nWeg der Freundschaft 4A\n07546 Gera\nTel.: +49 365 / 4341-118 und -119\nFax: +49 365 / 4341-105\nE-Mail: bibliothek@ba-gera.de\nInternet: http://bibliothek.ba-gera.de\n\nEisenach\nBibliothek der Berufsakademie Eisenach\nAm Wartenberg 2\n99817 Eisenach\nTel.: +49 3691 / 6294-72 und -12\nFax: +49 3691 / 6294-59\nE-Mail: bibliothek@ba-eisenach.de\nInternet: http://bibliothek.ba-eisenach.de";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Wim2";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Wim2", @"BA Gera", nil]];
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Wim2", @"BA Eisenach", nil]];
    self.currentBibSearchCountURL = @"";
    self.currentBibFeedURLIsWebsite = YES;
}

@end