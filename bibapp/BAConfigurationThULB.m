//
//  BAConfigurationThULB.m
//  bibapp
//
//  Created by Johannes Schultze on 24.04.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationThULB.h"

@implementation BAConfigurationThULB

- (void)initConfiguration
{
   self.currentBibSearchMaximumRecords = @"20";
   [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-27", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
   [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"http://daia.gbv.de/isil/DE-27", @"Standard-Katalog", nil]];
   [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://jenopc5.thulb.uni-jena.de:7242/DE-27", @"Standard-Katalog", nil]];
   self.currentBibFeedURL = @"http://www.thulb.uni-jena.de";
   [self.currentBibFeedURLs addObject:[[NSArray alloc] initWithObjects:@"http://www.thulb.uni-jena.de", @"Standard-Katalog", nil]];
   self.currentBibTintColor = [UIColor colorWithRed:0.337255F green:0.556863F blue:0.745098F alpha:1.0F];
   self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Vertreter", @"USt-IdNr.", @"Angaben zum Datenschutz", @"Rechtliche Hinweise zur Haftung", nil];
   [self.currentBibImprint setObject:@"Anbieter gemäß § 5 TMG\n\nThüringer Universitäts- und Landesbibliothek Jena (ThULB)\nVertreten durch: Dr. Sabine Wefers, Leitende Bibliotheksdirektorin\nBibliotheksplatz 2\n07743 Jena\nTel.: +49 3641 9-40000\nFax: +49 3641 9-40002\nwww.thulb.uni-jena.de/mailformulare/direktion-p-1013.html" forKey:@"Anbieter"];
   [self.currentBibImprint setObject:@"Die Thüringer Universitäts- und Landesbibliothek Jena ist eine Einrichtung der Friedrich-Schiller-Universität Jena. Die Friedrich-Schiller-Universität Jena ist eine Körperschaft des Öffentlichen Rechts. Sie wird gesetzlich vertreten durch Präsident Prof. Dr. Walter Rosenthal.\n\nFriedrich-Schiller-Universität Jena\nFürstengraben 1\n07743 Jena" forKey:@"Vertreter"];
   [self.currentBibImprint setObject:@"Die Umsatzsteueridentifikationsnummer der Friedrich-Schiller-Universität lautet\n\nDE 150546536" forKey:@"USt-IdNr."];
   [self.currentBibImprint setObject:@"Sie haben die Möglichkeit, Ihre bibliotheksspezifischen Zugangsdaten (Benutzernummer und Benutzerpasswort) auf Ihrem mobilen Endgerät zu speichern. Dazu aktivieren Sie unter „Optionen“ den Punkt „Zugangsdaten speichern“ für das jeweilige Konto. Mit dieser Aktivierung stimmen Sie der Speicherung Ihrer Zugangsdaten auf Ihrem mobilen Endgerät zu.\n\nDie BibApp kommuniziert beim Zugriff auf Katalog- und Nutzerkontofunktionen mit Servern der Verbundzentrale des Gemeinsamen Bibliotheksverbundes in Göttingen. Die Datenübertragung geschieht dabei über eine mit hohen Standards verschlüsselte Verbindung (HTTPS)." forKey:@"Angaben zum Datenschutz"];
   [self.currentBibImprint setObject:@"Diese App wurde mit großer Sorgfalt erstellt und geprüft; dennoch können wir aufgrund der technischen Rahmenbedingungen keine Gewähr für die Richtigkeit, Vollständigkeit und Aktualität der App und der angezeigten Inhalte geben. Eine Haftung der Thüringer Universitäts- und Landesbibliothek Jena für Schäden, die durch die Nutzung der App, der angebotenen Informationen oder durch Fehlfunktion der App entstehen ist grundsätzlich ausgeschlossen, sofern kein nachweislich vorsätzliches oder grob fahrlässiges Verschulden unsererseits vorliegt. Die Thüringer Universitäts- und Landesbibliothek behält sich vor, Teile der App ohne gesonderte Ankündigung zu ändern, zu ergänzen, zu löschen oder die Veröffentlichung der App zeitweise oder endgültig einzustellen.\n\nDiese App bietet Links auf Internetangebote anderer Betreiber. Für den Inhalt dieser externen Links sind ausschließlich deren Anbieter verantwortlich." forKey:@"Rechtliche Hinweise zur Haftung"];
   //[self.currentBibImprint setObject:@"..." forKey:@"Gestaltung und Umsetzung"];
   self.currentBibContact = @"Anschrift\nThüringer Universitäts- und Landesbibliothek Jena Postfach\n07743 Jena\nhttp://www.thulb.uni-jena.de\n\nAuskunft\nTelefon: +49 3641 9-40100\nE-Mail: info@thulb.uni-jena.de\n\nAusleihe\nTelefon: +49 3641 9-40110\nE-Mail: thulb_ausleihe@thulb.uni-jena.de";
   self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-27";
   [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-27", @"Standard-Katalog", nil]];
   self.currentBibSearchCountURL = @"http://www4.thulb.uni-jena.de/pwk/piwik.php?idsite=1&rec=1";
   self.currentBibFeedURLIsWebsite = YES;
}

@end
