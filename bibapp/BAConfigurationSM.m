//
//  BAConfigurationFHS.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationSM.h"

@implementation BAConfigurationSM

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-shm2", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Shm2", @"Standard-Katalog", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Shm2", @"Standard-Katalog", nil]];
    [self.currentBibFeedURLs addObject:[[NSArray alloc] initWithObjects:@"https://www.hs-schmalkalden.de/hochschule/einrichtungen/bibliothek.html", @"Standard-Katalog", nil]];
    self.currentBibTintColor = [UIColor colorWithRed:0.211765F green:0.305882F blue:0.427451F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Hochschule Schmalkalden\nCellarius Bibliothek\nBlechhammer, Haus I\n98574 Schmalkalden\nhttp://www.hs-schmalkalden.de/bibliothek\nTel.: 03683 6881785\nFax: 03683 6881923\nE-Mail: bibliothek@hs-schmalkalden.de" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit, Ihre bibliotheksspezifischen Zugangsdaten (Nutzernummer und -passwort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter \"Optionen\" den Punkt \"Zugangsdaten speichern\" für das jeweilige Konto. Damit stimmen Sie der Speicherung der Daten auf Ihrem mobilen Endgerät zu.\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes (VZG) in Göttingen. Die Datenübertragung geschieht dabei über eine verschlüsselte Verbindung (https)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Die BibApp wurde mit größter Sorgfalt erstellt und geprüft. Dennoch kann auf Grund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte gegeben werden. Eine Haftung der Cellarius Bibliothek Schmalkalden für Schäden, die durch die Nutzung der App, der angebotenen Funktionen oder durch Fehlfunktionen der App entstehen, ist grundsätzlich ausgeschlossen.\nDie Cellarius Bibliothek Schmalkalden behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\nDie App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"ursprünglich: UB Lüneburg, UB Hildesheim, VZG\nAnpassung: Hochschule Schmalkalden\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Hochschule Schmalkalden\nCellarius Bibliothek\nBlechhammer, Haus I\n98574 Schmalkalden\nhttps://www.hs-schmalkalden.de/hochschule/einrichtungen/bibliothek.html\nTel.: 03683 6881785\nFax: 03683 6881923\nE-Mail: bibliothek@hs-schmalkalden.de";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Shm2";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Shm2", @"Standard-Katalog", nil]];
    //self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=EM111&amp;page=20";
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"http://dbspixel.hbz-nrw.de/count?id=EM111&amp;page=20", @"Standard-Katalog", nil]];
    self.currentBibFeedURLIsWebsite = YES;
}

@end
