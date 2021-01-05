//
//  BATocViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 06.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <QuickLook/QuickLook.h>

@interface BATocViewController : UIViewController <WKNavigationDelegate>

@property (strong, nonatomic) NSString *url;
@property (weak, nonatomic) IBOutlet WKWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)cancelAction:(id)sender;

@end
