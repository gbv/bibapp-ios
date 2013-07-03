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

@implementation BAConfiguration

@synthesize searchTitle;
@synthesize currentBibSearchMaximumRecords;
@synthesize currentBibLocalSearchURL;
@synthesize currentBibLocalSearchURLs;
@synthesize currentBibDetailURL;
@synthesize currentBibPAIAURL;
@synthesize currentBibFeedURL;
@synthesize currentBibTintColor;
@synthesize currentBibImprintTitles;
@synthesize currentBibImprint;
@synthesize currentBibContact;
@synthesize currentBibLocationUri;
@synthesize currentBibSearchCountURL;

- (id)init {
    self = [super init];
    if (self) {
        self.currentBibLocalSearchURLs = [[NSMutableDictionary alloc] init];
        self.currentBibImprintTitles = [[NSMutableArray alloc] init];
        self.currentBibImprint = [[NSMutableDictionary alloc] init];
        
        self.searchTitle = @"Suche";
        self.hasLocalDetailURL = NO;
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

@end
