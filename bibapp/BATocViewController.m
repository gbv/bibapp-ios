//
//  BATocViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 06.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BATocViewController.h"
#import "BAAppDelegate.h"

@interface BATocViewController ()

@end

@implementation BATocViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.activityIndicator stopAnimating];
    [self.webView setBackgroundColor:[[UIColor alloc] initWithRed:0.0 green:0.0 blue:0.0 alpha:1.0]];
}

- (IBAction)cancelAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
