//
//  BAOptionsViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 04.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAOptionsViewControllerPad.h"
#import "BAAppDelegate.h"

@interface BAOptionsViewControllerPad ()

@end

@implementation BAOptionsViewControllerPad

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
	// Do any additional setup after loading the view.
    
    self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController.navigationBar setTintColor:self.appDelegate.configuration.currentBibTintColor];
    
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.options.saveLocalData) {
        [self.saveLocalSwith setOn:YES];
    }
    
    [self.versionLabel setText:[[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //Code for dissmissing this viewController by clicking outside it
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapBehind:)];
    [recognizer setNumberOfTapsRequired:1];
    recognizer.cancelsTouchesInView = NO; //So the user can still interact with controls in the modal view
    [self.view.window addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveLocalSwithAction:(id)sender
{
    BAAppDelegate *appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([sender isOn]) {
        [appDelegate.options setSaveLocalData:YES];
        [appDelegate.account setAccount:appDelegate.currentAccount];
        [appDelegate.account setPassword:appDelegate.currentPassword];
    } else {
        [appDelegate.options setSaveLocalData:NO];
        [appDelegate.account setAccount:nil];
        [appDelegate.account setPassword:nil];
    }
    NSError *error = nil;
    if (![[appDelegate managedObjectContext] save:&error]) {
        // Handle the error.
    }
}

- (void)handleTapBehind:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint location = [sender locationInView:nil]; //Passing nil gives us coordinates in the window
        //Then we convert the tap's location into the local view's coordinate system, and test to see if it's in or outside. If outside, dismiss the view.
        if (![self.view pointInside:[self.view convertPoint:location fromView:self.view.window] withEvent:nil]) {
            // Remove the recognizer first so it's view.window is valid.
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

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidUnload {
    [self setVersionLabel:nil];
    [super viewDidUnload];
}
@end
