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
@property (strong, nonatomic) NSMutableArray *currentBibLocalSearchURLs;
@property (strong, nonatomic) NSMutableArray *currentBibDetailURLs;
@property (strong, nonatomic) NSMutableArray *currentBibPAIAURLs;
@property (strong, nonatomic) NSString *currentBibFeedURL;
@property (strong, nonatomic) NSMutableArray *currentBibFeedURLs;
@property (strong, nonatomic) UIColor *currentBibTintColor;
@property (strong, nonatomic) NSMutableArray *currentBibImprintTitles;
@property (strong, nonatomic) NSMutableDictionary *currentBibImprint;
@property (strong, nonatomic) NSString *currentBibContact;
@property (strong, nonatomic) NSString *currentBibLocationURI;
@property (strong, nonatomic) NSMutableArray *currentBibLocationURIs;
@property (strong, nonatomic) NSString *currentBibSearchCountURL;
@property (strong, nonatomic) NSString *currentBibStandardCatalogue;
@property BOOL *currentBibHideDepartment;
@property BOOL *currentBibFeedURLIsWebsite;
@property BOOL *currentBibUsePAIAWrapper;
@property (strong, nonatomic) NSString *currentBibRequestTitle;

+ (id)createConfiguration;
- (void)initConfiguration;
- (NSString *)generateLocalDetailURLFor:(NSString *)ppn;
- (NSString *)getTitleForCatalog:(NSString *)catalogue;
- (NSString *)getURLForCatalog:(NSString *)catalogue;
- (NSString *)getDetailURLForCatalog:(NSString *)catalogue;
- (NSString *)getPAIAURLForCatalog:(NSString *)catalogue;
- (NSString *)getLocationURIForCatalog:(NSString *)catalogue;
- (NSString *)getSearchTitleForCatalog:(NSString *)catalogue;
- (NSString *)getFeedURLForCatalog:(NSString *)catalogue;
- (BOOL)usePAIAWrapper;

@end
