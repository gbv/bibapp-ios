//
//  BALocalizeHelper.m
//  bibapp
//
//  Created by Johannes Schultze on 19.07.18.
//  Copyright © 2018 Johannes Schultze. All rights reserved.
//

#import "BALocalizeHelper.h"

// Singleton
static BALocalizeHelper* SingleLocalSystem = nil;

// my Bundle (not the main bundle!)
static NSBundle* myBundle = nil;

@implementation BALocalizeHelper

//-------------------------------------------------------------
// allways return the same singleton
//-------------------------------------------------------------
+ (BALocalizeHelper*) sharedLocalSystem {
    // lazy instantiation
    if (SingleLocalSystem == nil) {
        SingleLocalSystem = [[BALocalizeHelper alloc] init];
    }
    return SingleLocalSystem;
}


//-------------------------------------------------------------
// initiating
//-------------------------------------------------------------
- (id) init {
    self = [super init];
    if (self) {
        // use systems main bundle as default bundle
        myBundle = [NSBundle mainBundle];
    }
    return self;
}


//-------------------------------------------------------------
// translate a string
//-------------------------------------------------------------
// you can use this macro:
// LocalizedString(@"Text");
- (NSString*) localizedStringForKey:(NSString*) key {
    // this is almost exactly what is done when calling the macro NSLocalizedString(@"Text",@"comment")
    // the difference is: here we do not use the systems main bundle, but a bundle
    // we selected manually before (see "setLanguage")
    
    return [myBundle localizedStringForKey:key value:@"" table:nil];
}

-(BOOL)existsLocalizedStringForKey:(NSString *)key {
    NSString *tempTranslation = [myBundle localizedStringForKey:key value:@"" table:nil];
    return ![tempTranslation isEqualToString:key];
}


//-------------------------------------------------------------
// set a new language
//-------------------------------------------------------------
// you can use this macro:
// LocalizationSetLanguage(@"German") or LocalizationSetLanguage(@"de");
- (void) setLanguage:(NSString*) lang {
    
    // path to this languages bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj" ];
    if (path == nil) {
        // there is no bundle for that language
        // use main bundle instead
        myBundle = [NSBundle mainBundle];
    } else {
        
        // use this bundle as my bundle from now on:
        myBundle = [NSBundle bundleWithPath:path];
        
        // to be absolutely shure (this is probably unnecessary):
        if (myBundle == nil) {
            myBundle = [NSBundle mainBundle];
        }
    }
}

-(NSString *)getLanguage {
    return [myBundle localizedStringForKey:@"Language" value:@"" table:nil];
}

@end
