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

@implementation BAConfiguration

@synthesize currentBibSearchMaximumRecords;
@synthesize currentBibLocalSearchURL;
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
        self.currentBibImprintTitles = [[NSMutableArray alloc] init];
        self.currentBibImprint = [[NSMutableDictionary alloc] init];
    }
    return self;
}

+ (id)createConfiguration {
    BAConfiguration *currentConfiguration;
    
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *bundleName = [NSString stringWithFormat:@"%@", [info objectForKey:@"CFBundleDisplayName"]];
    if([bundleName isEqualToString:@"BibApp LG"]){
        currentConfiguration = [[BAConfigurationLG alloc] init];
    } else if([bundleName isEqualToString:@"BibApp HI"]){
        currentConfiguration = [[BAConfigurationHI alloc] init];
    }
    [currentConfiguration initConfiguration];
    return currentConfiguration;
}

- (void)initConfiguration{
    // implement in subclasses
}

@end
