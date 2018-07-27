//
//  BALocalizeHelper.h
//  bibapp
//
//  Created by Johannes Schultze on 19.07.18.
//  Copyright © 2018 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

// some macros (optional, but makes life easy)

// Use "LocalizedString(key)" the same way you would use "NSLocalizedString(key,comment)"
#define BALocalizedString(key) [[BALocalizeHelper sharedLocalSystem] localizedStringForKey:(key)]

#define BALocalizedStringCheck(key) [[BALocalizeHelper sharedLocalSystem] existsLocalizedStringForKey:(key)]

#define BALocalizedLanguage [[BALocalizeHelper sharedLocalSystem] getLanguage]

// "language" can be (for american english): "en", "en-US", "english". Analogous for other languages.
#define BALocalizationSetLanguage(language) [[BALocalizeHelper sharedLocalSystem] setLanguage:(language)]

@interface BALocalizeHelper : NSObject

// a singleton:
+ (BALocalizeHelper*) sharedLocalSystem;

// this gets the string localized:
- (NSString*) localizedStringForKey:(NSString*) key;

// this gets the string localized:
- (BOOL) existsLocalizedStringForKey:(NSString*) key;

//set a new language:
- (void) setLanguage:(NSString*) lang;

//set a new language:
- (NSString *) getLanguage;

-(void)translateTabBar:(UITabBarController *) tabBarController;

@end
