//
//  BAConfiguration.m
//  bibapp
//
//  Created by Johannes Schultze on 20.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAConfiguration.h"
#import "BAConfigurationLG.h"
#import "BAConfigurationHI.h"
#import "BAConfigurationBLS.h"
#import "BAConfigurationIL.h"
#import "BAConfigurationHAWK.h"
#import "BAConfigurationThULB.h"
#import "BAConfigurationEAHJ.h"
#import "BAConfigurationUBWe.h"
#import "BAConfigurationDHGE.h"
#import "BAConfigurationHFMWe.h"
#import "BAConfigurationNDH.h"
#import "BAConfigurationFHE.h"
#import "BAConfigurationSM.h"
#import "BAConfigurationUFB.h"
#import "BAConfigurationTUBS.h"
#import "BAConfigurationAEZB.h"
#import "BAConfigurationCobi.h"

@implementation BAConfiguration

@synthesize searchTitle;
@synthesize currentBibSearchMaximumRecords;
@synthesize currentBibLocalSearchURLs;
@synthesize currentBibDetailURLs;
@synthesize currentBibPAIAURLs;
@synthesize currentBibFeedURL;
@synthesize currentBibFeedURLs;
@synthesize currentBibTintColor;
@synthesize currentBibImprintTitles;
@synthesize currentBibImprint;
@synthesize currentBibContact;
@synthesize currentBibLocationURI;
@synthesize currentBibLocationURIs;
@synthesize currentBibSearchCountURLs;
@synthesize currentBibStandardCatalogue;
@synthesize currentBibHideDepartment;
@synthesize currentBibFeedURLIsWebsite;
@synthesize currentBibRequestTitle;
@synthesize currentBibDaiaInfoFromOpacDisplay;
@synthesize pushServiceUrl;
@synthesize pushServiceApiKey;

- (id)init {
    self = [super init];
    if (self) {
        self.currentBibLocalSearchURLs = [[NSMutableArray alloc] init];
        self.currentBibDetailURLs = [[NSMutableArray alloc] init];
        self.currentBibPAIAURLs = [[NSMutableArray alloc] init];
        self.currentBibFeedURLs = [[NSMutableArray alloc] init];
        self.currentBibImprintTitles = [[NSMutableArray alloc] init];
        self.currentBibImprint = [[NSMutableDictionary alloc] init];
        self.currentBibLocationURIs = [[NSMutableArray alloc] init];
        self.currentBibSearchCountURLs = [[NSMutableArray alloc] init];
       
        self.searchTitle = @"Suche";
        self.hasLocalDetailURL = NO;
        
        self.currentBibStandardCatalogue = @"Standard-Katalog";
        
        self.currentBibHideDepartment = NO;
        self.currentBibFeedURLIsWebsite = NO;
        self.currentBibUsePAIAWrapper = NO;
       
        self.currentBibRequestTitle = @"Vormerken";
       
        self.currentBibDaiaInfoFromOpacDisplay = @"Verfügbarkeit im OPAC prüfen";
       
        self.useDAIAParser = YES;
        
        self.pushServiceUrl = @"172.20.10.2";
        self.pushServiceApiKey = @"123";
    }
    return self;
}

+ (id)createConfiguration
{
    BAConfiguration *currentConfiguration;
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleIdentifier = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleIdentifier"]];
    if([bundleIdentifier isEqualToString:@"de.leuphana.bibliothek.bibapp"]){
        currentConfiguration = [[BAConfigurationLG alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.uni-hildesheim.bib.bibapp"]){
        currentConfiguration = [[BAConfigurationHI alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.bls"]){
        currentConfiguration = [[BAConfigurationBLS alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.il"]){
        currentConfiguration = [[BAConfigurationIL alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.hawk-hhg.zimt.bibapp"]){
        currentConfiguration = [[BAConfigurationHAWK alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.thulb"]){
       currentConfiguration = [[BAConfigurationThULB alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.eahj"]){
       currentConfiguration = [[BAConfigurationEAHJ alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.ubwe"]){
       currentConfiguration = [[BAConfigurationUBWe alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.bat"]){
        currentConfiguration = [[BAConfigurationDHGE alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.hfmwe"]){
        currentConfiguration = [[BAConfigurationHFMWe alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.ndh"]){
        currentConfiguration = [[BAConfigurationNDH alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.fhe"]){
        currentConfiguration = [[BAConfigurationFHE alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.sm"]){
        currentConfiguration = [[BAConfigurationSM alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.ufb"]){
        currentConfiguration = [[BAConfigurationUFB alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.tubs"]){
       currentConfiguration = [[BAConfigurationTUBS alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.aezb"]){
       currentConfiguration = [[BAConfigurationAEZB alloc] init];
    } else if([bundleIdentifier isEqualToString:@"de.effective-webwork.bibapp.cobi"]){
       currentConfiguration = [[BAConfigurationCobi alloc] init];
    }
    [currentConfiguration initConfiguration];
    return currentConfiguration;
}

- (void)initConfiguration
{
    // implement in subclasses
}

- (NSString *)generateLocalDetailURLFor:(NSString *)ppn
{
    // implement in subclasses if needed. Set self.hasLocalDetailURL to YES!
    return nil;
}

- (NSString *)getTitleForCatalog:(NSString *)catalogue
{
    NSString *title;
    for (NSArray *tempCatalogue in self.currentBibLocalSearchURLs) {
        if ([[tempCatalogue objectAtIndex:1] isEqualToString:catalogue]) {
            title = [tempCatalogue objectAtIndex:2];
        }
    }
    return title;
}


- (NSString *)getURLForCatalog:(NSString *)catalogue
{
    NSString *url;
    for (NSArray *tempCatalogue in self.currentBibLocalSearchURLs) {
        if ([[tempCatalogue objectAtIndex:1] isEqualToString:catalogue]) {
            url = [tempCatalogue objectAtIndex:0];
        }
    }
    return url;
}

- (NSString *)getDetailURLForCatalog:(NSString *)catalogue
{
    NSString *url;
    for (NSArray *tempCatalogue in self.currentBibDetailURLs) {
        if ([[tempCatalogue objectAtIndex:1] isEqualToString:catalogue]) {
            url = [tempCatalogue objectAtIndex:0];
        }
    }
    return url;
}

- (NSString *)getPAIAURLForCatalog:(NSString *)catalogue
{
    NSString *url;
    for (NSArray *tempCatalogue in self.currentBibPAIAURLs) {
        if ([[tempCatalogue objectAtIndex:1] isEqualToString:catalogue]) {
            url = [tempCatalogue objectAtIndex:0];
        }
    }
    return url;
}

- (NSString *)getLocationURIForCatalog:(NSString *)catalogue
{
    NSString *url;
    for (NSArray *tempCatalogue in self.currentBibLocationURIs) {
        if ([[tempCatalogue objectAtIndex:1] isEqualToString:catalogue]) {
            url = [tempCatalogue objectAtIndex:0];
        }
    }
    return url;
}

- (NSString *)getSearchTitleForCatalog:(NSString *)catalogue
{
    NSString *title;
    for (NSArray *tempCatalogue in self.currentBibLocalSearchURLs) {
        if ([[tempCatalogue objectAtIndex:1] isEqualToString:catalogue]) {
            title = [tempCatalogue objectAtIndex:3];
        }
    }
    return title;
}

- (NSString *)getFeedURLForCatalog:(NSString *)catalogue
{
    NSString *title;
    for (NSArray *tempCatalogue in self.currentBibFeedURLs) {
        if ([[tempCatalogue objectAtIndex:1] isEqualToString:catalogue]) {
            title = [tempCatalogue objectAtIndex:0];
        }
    }
    return title;
}

- (NSString *)getSearchCountURLForCatalog:(NSString *)catalogue
{
   NSString *title;
   for (NSArray *tempCatalogue in self.currentBibSearchCountURLs) {
      if ([[tempCatalogue objectAtIndex:1] isEqualToString:catalogue]) {
         title = [tempCatalogue objectAtIndex:0];
      }
   }
   return title;
}

- (BOOL)usePAIAWrapper {
   return self.currentBibUsePAIAWrapper;
}

@end
