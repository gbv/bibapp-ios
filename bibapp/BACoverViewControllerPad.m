//
//  BACoverViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 06.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BACoverViewControllerPad.h"

@interface BACoverViewControllerPad ()

@end

@implementation BACoverViewControllerPad

- (void) viewDidAppear:(BOOL)animated
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   return YES;
}

@end
