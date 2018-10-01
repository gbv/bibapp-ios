//
//  BALanguageTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 18.07.18.
//  Copyright © 2018 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"

@interface BAOptionsLanguageTableViewController : UITableViewController

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property long selectedCellIndex;

@end
