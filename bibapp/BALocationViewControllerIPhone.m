//
//  BALocationViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 30.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BALocationViewControllerIPhone.h"

@interface BALocationViewControllerIPhone ()

@end

@implementation BALocationViewControllerIPhone

- (void)initSize{
    [super initSize];
    self.width = 320;
    self.mapViewHeight = 175;
    self.textViewHeight = 177;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
        self.top = 64;
    }
}

@end
