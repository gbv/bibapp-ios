//
//  BALocationViewControllerPad.m
//  bibapp
//
//  Created by Johannes Schultze on 26.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BALocationViewControllerPad.h"

@interface BALocationViewControllerPad ()

@end

@implementation BALocationViewControllerPad

- (void)initSize
{
    self.spacing = 20;
    self.spacingSplit = 330;
    self.width = 507;
    self.splitHeightTop = 300;
    self.splitHeightBottom = 270;
    self.completeHeight = 580;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

@end
