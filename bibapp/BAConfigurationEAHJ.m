//
//  BAConfigurationEAHJ.m
//  bibapp
//
//  Created by Johannes Schultze on 24.04.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationEAHJ.h"

@implementation BAConfigurationEAHJ

- (void)initConfiguration
{
   self.currentBibSearchMaximumRecords = @"20";
   [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-j59", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/de-j59", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://jenlbs6.thulb.uni-jena.de:7242/DE-J59", @"Standard-Katalog", nil]];
   self.currentBibFeedURL = @"http://www.fh-jena.de/fhj/bib/_layouts/listfeed.aspx?List=%7B3B9D0D4E%2D3239%2D4D61%2D8548%2D5868B08954AA%7D&Source=http%3A%2F%2Fwww%2Efh%2Djena%2Ede%2Ffhj%2Fbib%2FLists%2FAnkuendigungen%2FAllItems%2Easpx";
   self.currentBibTintColor = [[UIColor alloc] initWithRed:0.0 green:0.89 blue:0.85 alpha:1];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", @"Gestaltung und Umsetzung", nil];
   [self.currentBibImprint setObject:@"Ernst Abbe Hochschule Jena (EAH Jena)\n\nCarl Zeiss Promenade 2\n07745 Jena\n\nE-Mail: Bibliothek@fh-jena.de\n\nTelefon: +49 (0) 3641- 205 270\nTelefax: +49 (0) 3641- 205 271" forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Die Bibliothek der EAH Jena   umfasst mehrere Informationsbereiche die Bibliothek, das Patentinformationszentrum (PIZ), das EAH-Patentbüro, die Auftragsrecherche, das Hochschularchiv, die DIN-Auslegestelle und den Verlag der EAH Jena. Als Dienstleister stellen wir gewünschte Fachinformationen für Lehre, Forschung und Studium von der Recherche bis zur Quellenbereitstellung zur Verfügung. Die Bibliothek ist ein Kernzentrum der Lehre. Das abgedeckte Informationsspektrum basiert neben den Grundlagen der Ausbildungsziele in den Fachbereichen der Hochschule, auch auf dem Informationsbedarf der Region. Die Bibliothek versteht sich als:\n- Informationsdienstleister\n- Vermittler von Informationskompetenz in der Lehre\n- als soziale Einrichtung für die Studierenden\n- und Lernort.\nDie Bibliothek wird vertreten durch ihrenLeiter, Dipl.-Math. Lothar Löbnitz. Die EAH Jena ist eine Körperschaft des öffentlichen Rechts, vertreten durch ihre Präsidentin Frau Prof. Gabriele Beibst\n\nUmsatzsteuer-Identifikationsnummer gemäß § 27 a Umsatzsteuergesetz:\nDE 811481421." forKey:@"Vertreter"];
   [self.currentBibImprint setObject:@"Sie haben die Möglichkeit Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“ für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu.\n\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"Diese App wurde von der EAH Jena mit großer Sorgfalt erstellt und geprüft, dennoch können wir aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte geben. Eine Haftung der EAH Jena  für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt. Die Hochschulbibliothek der EAH Jena behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\n\nDiese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Seiten sind ausschließlich deren Betreiber verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
   [self.currentBibImprint setObject:@"Entwurf und Konzeption\nA. Christensen (UB Lüneburg),\nL. Löbnitz (EAH Jena),\nJ. Voss (VZG Göttingen)\n\nUmsetzung\neffective WEBWORK GmbH" forKey:@"Gestaltung und Umsetzung"];
    self.currentBibContact = @"Anschrift\nEAH Jena\nCarl Zeiss Promenade 2\n07745 Jena\nwww.fh-jena.de/bib\n\nTelefon: (03641) 205-270\nE-Mail: bibliothek@fh-jena.de\n\nAusleihe\nTelefon: (03641) 205-280  oder …290\nE-Mail: ausleihe@fh-jena.de\n\nFernleihe\nTelefon: (03641) 205-283\nE-Mail: Fernleihe@fh-jena.de\n\nPatentinformationszentrum (PIZ)\nTelefon: (03641) 205-2275 oder …273\nE-Mail: PIZ@fh-jena.de";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-J59";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-J59", @"Standard-Katalog", nil]];
}

@end
