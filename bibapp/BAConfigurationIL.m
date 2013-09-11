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
    self.currentBibLocalSearchURL = @"opac-de-ilm1";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-ilm1", @"Standard-Katalog", @"Lokale Suche", nil]];
    self.currentBibDetailURL = @"http://daia.gbv.de/isil/DE-Ilm1";
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-Ilm1", @"Standard-Katalog", nil]];
    self.currentBibPAIAURL = @"https://paia.gbv.de/isil/DE-Ilm1";
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/isil/DE-Ilm1", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"http://www2.tu-ilmenau.de/ub/weblog/?feed=rss2";
    self.currentBibTintColor = [[UIColor alloc] initWithRed:0.0 green:0.45 blue:0.47 alpha:1.0];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Angaben zum Datenschutz", @"Zählpixelverfahren Deutsche Bibliotheksstatistik", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Universitätsbibliothek Ilmenau\nDer Direktor\nLangewiesener Str.37\n98693 Ilmenau\nhttp://www.tu-ilmenau.de/ub/\nTel.: 03677 69-4701\nFax: 03677 69-4700\nE-Mail: direktion.ub@tu-ilmenau.de\nImpressum der TU Ilmenau:\nhttp://www.tu-ilmenau.de/impressum/" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit, Ihre bibliotheksspezifischen Zugangsdaten (Nutzernummer und -passwort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter \"Optionen\" den Punkt \"Zugangsdaten speichern\" für das jeweilige Konto. Damit stimmen Sie der Speicherung der Daten auf Ihrem mobilen Endgerät zu. Die BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes (VZG) in Göttingen. Die Datenübertragung geschieht dabei über eine verschlüsselte Verbindung (https)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Die Universitätsbibliothek der Technischen Universität Ilmenau nutzt im Rahmen ihrer Teilnahme an der Deutschen Bibliotheksstatistik ein Verfahren zur Zählung der Besuche auf den Katalogseiten. Es wird eine Kennung der Bibliothek und der betreffenden Seite, der Zeitpunkt des Aufrufs und eine Signatur des aufrufenden Gerätes gespeichert.\nDie Signatur wird mittels einer Einwegfunktion aus IP-Adresse, Kennung des zugreifenden Programms und Proxy-Information gebildet. Die Erhebung, Speicherung und Auswertung dieser Daten erfolgt in pseudonymisierter Form, d.h. die Signatur ist nicht bestimmten Personen zuzuordnen. Eine Speicherung insbesondere der IP-Adresse findet nicht statt. Die pseudonymen Einzeldaten werden nach spätestens 24 Stunden aufsummiert und damit anonymisiert.\nDie gespeicherten Daten werden statistisch ausgewertet, um die Internetangebote bedarfsgerecht zu gestalten und weiterzuentwickeln. Die Daten werden nur zu diesem Zweck genutzt und im Anschluss an die Auswertung gelöscht.\nMit der technischen und organisatorischen Umsetzung des Verfahrens ist die Hochschule der Medien Stuttgart beauftragt. Sie hat das Verfahren nach den Maßgaben der gesetzlichen Bestimmungen der Datenschutzgesetze und des Telemediengesetzes (TMG) entwickelt und sich zu deren Einhaltung verpflichtet.\nSie haben die Möglichkeit, die Erhebung der genannten Daten im Menü \"Optionen\" im Punkt \"Zählpixel\" zu deaktivieren." forKey:@"Zählpixelverfahren Deutsche Bibliotheksstatistik"];
    [self.currentBibImprint setObject:@"Die BibApp wurde mit größter Sorgfalt erstellt und geprüft. Dennoch kann auf Grund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte gegeben werden. Eine Haftung für Schäden, die durch die Nutzung der App, der angebotenen Funktionen oder durch Fehlfunktionen der App entstehen, ist grundsätzlich ausgeschlossen.\nEs wird sich vorbehalten, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\nDie App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"ursprünglich: UB Lüneburg, UB Hildesheim, VZG\nAnpassung: UB Ilmenau\nUmsetzung: effective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Universitätsbibliothek Ilmenau\nLangewiesener Str.37\n98693 Ilmenau\n\nhttp://www.tu-ilmenau.de/ub/\n\nAuskunft:\nTel.: 03677 69-4531\nE-Mail: auskunft.ub@tu-ilmenau.de\n\nDirektion:\nTel.: 03677 69-4701\nE-Mail: direktion.ub@tu-ilmenau.de";
    self.currentBibLocationUri = @"http://uri.gbv.de/organization/isil/DE-Ilm1";
    self.currentBibSearchCountURL = @"http://dbspixel.hbz-nrw.de/count?id=EL039&amp;page=20";
}

@end