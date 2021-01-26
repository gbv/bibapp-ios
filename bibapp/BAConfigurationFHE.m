//
//  BAConfigurationFHE.m
//  bibapp
//
//  Created by Johannes Schultze on 17.06.14.
//  Copyright (c) 2014 Johannes Schultze. All rights reserved.
//

#import "BAConfigurationFHE.h"

@implementation BAConfigurationFHE

- (void)initConfiguration
{
    self.currentBibSearchMaximumRecords = @"20";
    [self.currentBibLocalSearchURLs addObject:[[NSArray alloc] initWithObjects:@"opac-de-546", @"Standard-Katalog", @"Lokale Suche", @"Lokale Suche", nil]];
    [self.currentBibDetailURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-546/daia", @"Standard-Katalog", nil]];
    [self.currentBibPAIAURLs addObject:[[NSArray alloc] initWithObjects:@"https://paia.gbv.de/DE-546", @"Standard-Katalog", nil]];
    self.currentBibFeedURL = @"http://www.fh-erfurt.de/fhe/?id=663&type=100&tx_ttnews[cat]=2";
    self.currentBibTintColor = [UIColor colorWithRed:0.000000F green:0.200000F blue:0.400000F alpha:1.0F];
    self.currentBibImprintTitles = [[NSMutableArray alloc] initWithObjects:@"Anbieter", @"Datenschutzerklärung", nil];
    [self.currentBibImprint setObject:@"Fachhochschule Erfurt\nBibliothek\nAltonaer Straße 25\n99085 Erfurt\n\nTel.: 0361 6700-519\nFax: 0361 6700-518\n\nDie Fachhochschule Erfurt ist eine Körperschaft des öffentlichen Rechts.\nSie wird durch den Leiter der Hochschule Prof. Dr.-Ing. Volker Zerbe gesetzlich vertreten.\nUSt-Id-Nr: DE 241 446 583\n\nZuständige Aufsichtsbehörde:\nThüringer Ministerium für Bildung, Wissenschaft und Kultur\nWerner-Seelenbinder Straße 7\n99096 Erfurt\n\nTechnische Betreuung:\nHochschulbibliothek der FHE\nAltonaer Straße 25\n99085 Erfurt" forKey:@"Anbieter"];
    [self.currentBibImprint setObject:@"Nutzerdaten (Bibliotheks-Kennung/Nutzername und Passwort) werden nur beim Anmelden über die Kontofunktionalität übertragen. Der Zugriff auf das persönliche Bibliothekskonto erfolgt ausschließlich über abhörsichere HTTPS Anfragen an das lokale Bibliothekssystem. Die Daten werden somit in Echtzeit direkt vom Bibliothekssystem abgefragt.\n\nVon der App werden folgende Daten an Schnittstellen übertragen:\n- Eingaben in das Suchfeld an http://opac.uni-erfurt.de/DB=4/\n- PPN-Angaben zu einzelnen Einträgen an https://unapi.k10plus.de und http://daia.gbv.de/DE-546\n- Benutzername und Passwort an https://paia.gbv.de/DE-546/\n- Standort-URIs an  http://uri.gbv.de/organization/isil/DE-546\n- ISBN-Angaben an http://ws.gbv.de\n\nDie App selbst sammelt und speichert keine Daten dauerhaft. Wenn der Nutzer es erlaubt, werden Benutzername und Passwort für den Zugriff auf die Kontofunktion gespeichert. Dies ist aber im Bereich \"Optionen\" auch wieder widerrufbar.\n\nSie haben das Recht, jederzeit Auskunft über die zu Ihrer Person gespeicherten Daten zu erhalten, einschließlich Herkunft und Empfänger Ihrer Daten sowie den Zweck der Datenverarbeitung. Diese Datenschutzerklärung gilt nur für Inhalte auf unseren Servern und umfasst nicht die auf unserer Seite verlinkten Webseiten.\n\nWeitere Informationen bezüglich der Verarbeitung Ihrer persönlichen Daten im lokalen Bibliotheksystem finden Sie in der Rahmendienstvereinbarung zum Bibliothekssystem PICA sowie in der Benutzungsordnung der Hochschulbibliothek der Fachhochschule Erfurt." forKey:@"Datenschutzerklärung"];
    self.currentBibContact = @"Altonaer Straße 25\n99085 Erfurt\n\nAusleihtheke:\nTel.: 0361 6700-519\nFax: 0361 6700-518\n\nE-Mail: bibliothek@fh-erfurt.de ";
    self.currentBibLocationURI = @"http://uri.gbv.de/organization/isil/DE-546";
    [self.currentBibLocationURIs addObject:[[NSArray alloc] initWithObjects:@"http://uri.gbv.de/organization/isil/DE-546", @"Standard-Katalog", nil]];
    self.pushServiceGoogleServiceFile = @"GoogleService-Info";
}

@end
