//
//  BAConfigurationIL.m
//  bibapp
//
//  Created by Johannes Schultze on 01.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationIL.h"

@implementation BAConfigurationIL

- (void)initConfiguration{
    self.hasLocalDetailURL = YES;
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibLocalSearchURL = @"opac-de-ilm1";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-ilm1", @"Standard-Katalog", @"Lokale Suche", nil]];
    self.currentBibDetailURL = @"http://daia.gbv.de/isil/DE-Ilm1";
    self.currentBibPAIAURL = @"https://paia-il.effective-webwork.de";
    self.currentBibFeedURL = @"http://www2.tu-ilmenau.de/ub/weblog/?feed=rss2";
    self.currentBibTintColor = [[UIColor alloc] initWithRed:0.0 green:0.45 blue:0.47 alpha:1.0];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Universitätsbibliothek Ilmenau\n\nDer Direktor\n\nLangewiesener Str.37\n\n98693 Ilmenau\n\nhttp://www.tu-ilmenau.de/ub/\n\nTel.: 03677 69-4701\n\nFax: 03677 69-4700\n\nE-Mail: direktion.ub@tu-ilmenau.de\n\nImpressum der TU Ilmenau:\n\nhttp://www.tu-ilmenau.de/impressum/" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit, Ihre bibliotheksspezifischen Zugangsdaten (Nutzernummer und -passwort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter \"Optionen\" den Punkt \"Zugangsdaten speichern\" für das jeweilige Konto. Damit stimmen Sie der Speicherung der Daten auf Ihrem mobilen Endgerät zu. Die BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes (VZG) in Göttingen. Die Datenübertragung geschieht dabei über eine verschlüsselte Verbindung (https)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Die BibApp wurde mit größter Sorgfalt erstellt und geprüft. Dennoch kann auf Grund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte gegeben werden. Eine Haftung der UB Ilmenau für Schäden, die durch die Nutzung der App, der angebotenen Funktionen oder durch Fehlfunktionen der App entstehen, ist grundsätzlich ausgeschlossen. Die UB Ilmenau behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\n\nDie App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"ursprünglich: UB Lüneburg, UB Hildesheim, VZG\n\nAnpassung: UB Ilmenau\n\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Universitätsbibliothek Ilmenau\n\nLangewiesener Str.37\n\n98693 Ilmenau\n\nhttp://www.tu-ilmenau.de/ub/\n\nAuskunft:\n\nTel.: 03677 69-4531\n\nE-Mail: auskunft.ub@tu-ilmenau.de\n\nDirektion:\n\nTel.: 03677 69-4701\n\nE-Mail: direktion.ub@tu-ilmenau.de";
    self.currentBibLocationUri = @"http://uri.gbv.de/organization/isil/DE-Ilm1";
    self.currentBibSearchCountURL = @"";
}

- (NSString *)generateLocalDetailURLFor:(NSString *)ppn
{
    return [[NSString alloc] initWithFormat:@"http://find.bibliothek.tu-ilmenau.de/phpDaia/daia_ws.php?ppn=%@&format=xml", ppn];
}

@end
