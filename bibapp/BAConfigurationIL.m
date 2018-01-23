//
//  BAConfigurationIL.m
//  bibapp
//
//  Created by Johannes Schultze on 01.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationIL.h"

@implementation BAConfigurationIL

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-ilm1", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Ilm1", @"Standard-Katalog", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Ilm1", @"Standard-Katalog", nil]];
    [self.currentBibFeedURLs addObject:[[NSArray alloc] initWithObjects:@"http://www.tu-ilmenau.de/ub/nachrichtenarchiv/", @"Standard-Katalog", nil]];
    self.currentBibFeedURLIsWebsite = YES;
    self.currentBibTintColor = [[UIColor alloc] initWithRed:0.0 green:0.45 blue:0.47 alpha:1.0];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Angaben zum Datenschutz", @"Statistik", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Universitätsbibliothek Ilmenau\nDer Direktor\nLangewiesener Str.37\n98693 Ilmenau\nhttp://www.tu-ilmenau.de/ub/\nTel.: 03677 69-4701\nFax: 03677 69-4700\nE-Mail: direktion.ub@tu-ilmenau.de\nImpressum der TU Ilmenau:\nhttp://www.tu-ilmenau.de/impressum/" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit, Ihre bibliotheksspezifischen Zugangsdaten (Nutzernummer und -passwort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter \"Optionen\" den Punkt \"Zugangsdaten speichern\" für das jeweilige Konto. Damit stimmen Sie der Speicherung der Daten auf Ihrem mobilen Endgerät zu. Die BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes (VZG) in Göttingen. Die Datenübertragung geschieht dabei über eine verschlüsselte Verbindung (https)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Die Universitätsbibliothek setzt den Webanalysedienst Matomo zur Verbesserung und Optimierung des Angebotes ein. Die IP-Adressen der zugreifenden Geräte werden unmittelbar beim Zugriff anonymisiert und anonymisiert gespeichert. Die erlangten Informationen werden nicht an Dritte weitergegeben, eine Zusammenführung der erhobenen Nutzerdaten und möglicher Ausleihdaten erfolgt nicht.\nSie haben die Möglichkeit, die Erhebung der Daten im Menü \"Optionen\" im Punkt \"Anonyme Nutzungsdaten speichern\" zu deaktivieren." forKey:@"Statistik"];
    [self.currentBibImprint setObject:@"Die BibApp wurde mit größter Sorgfalt erstellt und geprüft. Dennoch kann auf Grund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte gegeben werden. Eine Haftung für Schäden, die durch die Nutzung der App, der angebotenen Funktionen oder durch Fehlfunktionen der App entstehen, ist grundsätzlich ausgeschlossen.\nEs wird sich vorbehalten, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\nDie App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"ursprünglich: UB Lüneburg, UB Hildesheim, VZG\nAnpassung: UB Ilmenau\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Universitätsbibliothek Ilmenau\nLangewiesener Str.37\n98693 Ilmenau\n\nhttp://www.tu-ilmenau.de/ub/\n\nAuskunft:\nTel.: 03677 69-4531\nE-Mail: auskunft.ub@tu-ilmenau.de\n\nDirektion:\nTel.: 03677 69-4701\nE-Mail: direktion.ub@tu-ilmenau.de";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Ilm1";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Ilm1", @"Standard-Katalog", nil]];
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"https://pw.bibliothek.tu-ilmenau.de/piwik.php?idsite=3&rec=1", @"Standard-Katalog", nil]];
    self.currentBibDaiaInfoFromOpacDisplay = @"nicht ausleihbar";
    self.usePushService = YES;
    self.pushServiceUrl = @"http://192.168.2.237:8080/app_dev.php";
    self.pushServiceApiKey = @"123";
    self.pushServiceGoogleServiceFile = @"GoogleService-Info-IL";
}

@end
