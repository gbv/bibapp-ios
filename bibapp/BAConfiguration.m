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
#import "BAConfigurationBAT.h"
#import "BAConfigurationHFMWe.h"
#import "BAConfigurationNDH.h"
#import "BAConfigurationFHE.h"
#import "BAConfigurationSM.h"
#import "BAConfigurationUFB.h"

@implementation BAConfiguration

@synthesize searchTitle;
@synthesize currentBibSearchMaximumRecords;
@synthesize currentBibLocalSearchURL;
@synthesize currentBibLocalSearchURLs;
@synthesize currentBibDetailURL;
@synthesize currentBibDetailURLs;
@synthesize currentBibPAIAURL;
@synthesize currentBibPAIAURLs;
@synthesize currentBibFeedURL;
@synthesize currentBibTintColor;
@synthesize currentBibImprintTitles;
@synthesize currentBibImprint;
@synthesize currentBibContact;
@synthesize currentBibLocationURI;
@synthesize currentBibLocationURIs;
@synthesize currentBibSearchCountURL;
@synthesize currentBibStandardCatalogue;
@synthesize currentBibHideDepartment;

- (id)init {
    self = [super init];
    if (self) {
        self.currentBibLocalSearchURLs = [[NSMutableArray alloc] init];
        self.currentBibDetailURLs = [[NSMutableArray alloc] init];
        self.currentBibPAIAURLs = [[NSMutableArray alloc] init];
        self.currentBibImprintTitles = [[NSMutableArray alloc] init];
        self.currentBibImprint = [[NSMutableDictionary alloc] init];
        self.currentBibLocationURIs = [[NSMutableArray alloc] init];
        
        self.searchTitle = @"Suche";
        self.hasLocalDetailURL = NO;
        
        self.currentBibStandardCatalogue = @"Standard-Katalog";
        
        self.currentBibHideDepartment = NO;
    }
    return self;
}

+ (id)createConfiguration
{
    BAConfiguration *currentConfiguration;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleDisplayName"]];
   
    if([bundleName isEqualToString:@"BibApp LG"]){
        currentConfiguration = [[BAConfigurationLG alloc] init];
    } else if([bundleName isEqualToString:@"BibApp HI"]){
        currentConfiguration = [[BAConfigurationHI alloc] init];
    } else if([bundleName isEqualToString:@"BibApp BLS"]){
        currentConfiguration = [[BAConfigurationBLS alloc] init];
    } else if([bundleName isEqualToString:@"BibApp IL"]){
        currentConfiguration = [[BAConfigurationIL alloc] init];
    } else if([bundleName isEqualToString:@"BibApp HAWK"]){
        currentConfiguration = [[BAConfigurationHAWK alloc] init];
    } else if([bundleName isEqualToString:@"BibApp ThULB"]){
       currentConfiguration = [[BAConfigurationThULB alloc] init];
    } else if([bundleName isEqualToString:@"BibApp EAHJ"]){
       currentConfiguration = [[BAConfigurationEAHJ alloc] init];
    } else if([bundleName isEqualToString:@"BibApp BUW"]){
       currentConfiguration = [[BAConfigurationUBWe alloc] init];
    } else if([bundleName isEqualToString:@"BibApp BAT"]){
        currentConfiguration = [[BAConfigurationBAT alloc] init];
    } else if([bundleName isEqualToString:@"BibApp HFMW"]){
        currentConfiguration = [[BAConfigurationHFMWe alloc] init];
    } else if([bundleName isEqualToString:@"BibApp FHN"]){
        currentConfiguration = [[BAConfigurationNDH alloc] init];
    } else if([bundleName isEqualToString:@"BibApp FHE"]){
        currentConfiguration = [[BAConfigurationFHE alloc] init];
    } else if([bundleName isEqualToString:@"BibApp FHS"]){
        currentConfiguration = [[BAConfigurationSM alloc] init];
    } else if([bundleName isEqualToString:@"BibApp UBE"]){
        currentConfiguration = [[BAConfigurationUFB alloc] init];
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

@end
