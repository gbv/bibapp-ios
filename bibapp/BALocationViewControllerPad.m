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
    [super initSize];
    self.width = 507;
    self.mapViewHeight = 300;
    self.textViewHeight = 270;
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

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Code for dissmissing this viewController by clicking outside it
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    recognizer.delegate = self;
    recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer:recognizer];
    
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
   if (sender.state == UIGestureRecognizerStateEnded) {
      UIView *rootView = self.view.window.rootViewController.view;
      CGPoint location = [sender locationInView:rootView];
      if (![self.view pointInside:[self.view convertPoint:location fromView:rootView] withEvent:nil]) {
         [self.view.window removeGestureRecognizer:sender];
         [self dismissViewControllerAnimated:YES completion:nil];
      }
   }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   return YES;
}

@end
