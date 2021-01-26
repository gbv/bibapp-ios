//
//  BAConfigurationHAWK.m
//  bibapp
//
//  Created by Johannes Schultze on 01.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationHAWK.h"

@implementation BAConfigurationHAWK

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    self.currentBibStandardCatalogue = @"HAWK Bibliothek – Gesamtbestand";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-hil3", @"HAWK Bibliothek – Gesamtbestand", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/de-hil3", @"HAWK Bibliothek – Gesamtbestand", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-Hil3", @"HAWK Bibliothek – Gesamtbestand", nil]];
    self.currentBibFeedURL = @"";
    self.currentBibTintColor = [[UIColor alloc] initWithRed:0.01 green:0.11 blue:0.26 alpha:1.0];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Impressum", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
    [self.currentBibImprint setObject:@"Hochschule für angewandte Wissenschaft und Kunst\nHildesheim/Holzminden/Göttingen\nPräsidentin: Prof. Dr. Christiane Dienel\nHohnsen 4\n31134 Hildesheim\nTelefon: +49(0)5121 881-0\nFax: +49(0)5121 881-132\nInternetadresse:http://www.hawk-hhg.de/\n\nUmsatzsteueridentifikationsnummer: 154261014\nDie Hochschule für angewandte Wissenschaft und Kunst - Hildesheim/Holzminden/Göttingen ist eine Körperschaft des öffentlichen Rechts.\nZuständige Aufsichtsbehörde:\nNiedersächsisches Ministerium für Wissenschaft und Kultur (MWK)\nLeibnizufer 9\n30169 Hannover" forKey:@"Impressum"];
    [self.currentBibImprint setObject:@"Sie haben die Möglichkeit Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter \"Optionen\" den Punkt \"Zugangsdaten speichern\" für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu. Die HAWK BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
    [self.currentBibImprint setObject:@"Diese App wurde von der Bibliothek der HAWK in Kooperation mit den Universitätsbibliotheken Hildesheim und Lüneburg und der effective WWEBWORK GmbH mit großer Sorgfalt erstellt und geprüft, dennoch kann aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte gegeben werden. Eine Haftung der Bibliothek der HAWK für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt. Die Bibliothek der HAWK behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen. Diese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
    [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg), J. Schrader (UB Hildesheim), J. Voss (VZG Göttingen)\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"HAWK Hochschule für angewandte Wissenschaft und Kunst\nHildesheim/Holzminden/Göttingen\nhttp://www.hawk-hhg.de/bibliothek/default.php\n\nHildesheim\nBibliothek auf dem Campus\nRenatastr. 11 Haus A\n31134 Hildesheim\nTel.: +49(0)5121 881-119\nE-Mail: bibliothek.bib@hawk-hhg.de\n\nHolzminden\nBibliothek Management, Soziale Arbeit, Bauen\nBillerbeck 2\n37603 Holzminden\nTel.: +49(0)5531 126-256\nE-Mail: bibliothek-hol.bib@hawk-hhg.de\n\nGöttingen\nBibliothek Ressourcenmanagement\nBüsgenweg 1A\n37077 Göttingen\nTel.: +49(0)551 5032-153\nE-Mail: bibliothek-r.bib@hawk-hhg.de\n\nBibliothek Naturwissenschaften und Technik\nVon-Ossietzky-Str. 99\n37085 Göttingen\nTel.: +49(0)551 3705-156\nE-Mail: bibliothek-n.bib@hawk-hhg.de";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-Hil3";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-Hil3", @"HAWK Bibliothek – Gesamtbestand", nil]];
    [self.currentBibSearchCountURLs addObject:[[NSArray alloc] initWithObjects:@"http://dbspixel.hbz-nrw.de/count?id=BC061&page=20", @"HAWK Bibliothek – Gesamtbestand", nil]];
}

@end
