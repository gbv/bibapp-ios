//
//  BibApp_IL_UI_Tests.m
//  BibApp IL UI Tests
//
//  Created by Johannes Schultze on 10.09.21.
//  Copyright © 2021 Johannes Schultze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BibApp_IL_UI_Tests-Swift.h"

@interface BibApp_IL_UI_Tests : XCTestCase

@end

@implementation BibApp_IL_UI_Tests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app waitForAnimations:NO];
    [app launch];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testScreenshot {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *searchField = [[[[[[[[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeSearchField].element;
    [searchField tap];
    
    [Snapshot snapshot:@"01SearchScreen" timeWaitingForIdle:10];
    
    [[[XCUIApplication alloc] init].tabBars[@"Tab Bar"].buttons[@"Info"] tap];

    [Snapshot snapshot:@"02InfoScreen" timeWaitingForIdle:10];
    
    [[[XCUIApplication alloc] init].tabBars[@"Tab Bar"].buttons[@"Optionen"] tap];

    [Snapshot snapshot:@"03InfoScreen" timeWaitingForIdle:10];
}

@end
