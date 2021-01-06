//
//  BAPDFViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 20.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAPDFViewController.h"

@interface BAPDFViewController ()

@end

@implementation BAPDFViewController

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
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(10, 10, 300, 460)];
    
    NSURL *targetURL = [NSURL URLWithString:@"http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIWebView_Class/UIWebView_Class.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
