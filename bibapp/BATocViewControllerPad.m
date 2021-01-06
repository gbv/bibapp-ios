//
//  BATocViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 06.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BATocViewControllerPad.h"
#import "BAAppDelegate.h"

@interface BATocViewControllerPad ()

@end

@implementation BATocViewControllerPad

@synthesize url;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView setNavigationDelegate:self];
    
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.toolbar setTintColor:appDelegate.configuration.currentBibTintColor];
    
	// Do any additional setup after loading the view.
    NSURL *targetURL = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicator stopAnimating];
    [self.webView setBackgroundColor:[[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return YES;
    } else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
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

@end
