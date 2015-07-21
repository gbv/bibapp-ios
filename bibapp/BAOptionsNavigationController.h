//
//  BAOptionsNavigationController.h
//  bibapp
//
//  Created by Johannes Schultze on 02.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAccountViewControllerPad.h"

@interface BAOptionsNavigationController : UINavigationController <UIGestureRecognizerDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (weak, nonatomic) BAAccountViewControllerPad *accountViewController;

@end
