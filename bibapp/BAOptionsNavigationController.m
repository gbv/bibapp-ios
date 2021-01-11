//
//  BAOptionsNavigationController.m
//  bibapp
//
//  Created by Johannes Schultze on 02.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BAOptionsNavigationController.h"

@interface BAOptionsNavigationController ()

@end

@implementation BAOptionsNavigationController

@synthesize accountViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)shouldAutorotate
{
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];

    if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        return YES;
    } else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
        return YES;
    } else {
        return NO;
    }
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
   return YES;
}

- (void)viewWillDisappear:(BOOL)animated {
   [super viewWillDisappear:animated];
   
   if (self.accountViewController != nil) {
      if (!self.appDelegate.isLoggedIn) {
         [self.accountViewController loginActionWithMessage:@""];
      }
   }
}

@end
