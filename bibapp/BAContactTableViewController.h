//
//  BAContactTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 04.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"

@interface BAContactTableViewController : UITableViewController

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextView *contactText;

@end
