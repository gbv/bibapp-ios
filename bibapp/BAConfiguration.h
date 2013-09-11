//
//  BAConfiguration.h
//  bibapp
//
//  Created by Johannes Schultze on 20.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAConfiguration : NSObject

@property (strong, nonatomic) NSString *searchTitle;
@property BOOL *hasLocalDetailURL;
@property (strong, nonatomic) NSString *currentBibSearchMaximumRecords;
@property (strong, nonatomic) NSString *currentBibLocalSearchURL;
@property (strong, nonatomic) NSMutableArray *currentBibLocalSearchURLs;
@property (strong, nonatomic) NSString *currentBibDetailURL;
@property (strong, nonatomic) NSMutableArray *currentBibDetailURLs;
@property (strong, nonatomic) NSString *currentBibPAIAURL;
@property (strong, nonatomic) NSString *currentBibFeedURL;
@property (strong, nonatomic) UIColor *currentBibTintColor;
@property (strong, nonatomic) NSMutableArray *currentBibImprintTitles;
@property (strong, nonatomic) NSMutableDictionary *currentBibImprint;
@property (strong, nonatomic) NSString *currentBibContact;
@property (strong, nonatomic) NSString *currentBibLocationUri;
@property (strong, nonatomic) NSString *currentBibSearchCountURL;
@property (strong, nonatomic) NSString *currentBibStandardCatalogue;

+ (id)createConfiguration;
- (void)initConfiguration;
- (NSString *)generateLocalDetailURLFor:(NSString *)ppn;
- (NSString *)getTitleForCatalog:(NSString *)catalogue;
- (NSString *)getURLForCatalog:(NSString *)catalogue;
- (NSString *)getDetailURLForCatalog:(NSString *)catalogue;

@end
