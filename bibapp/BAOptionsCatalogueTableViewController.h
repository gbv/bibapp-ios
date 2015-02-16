//
//  BAOptionsCatalogueTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 02.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"

@interface BAOptionsCatalogueTableViewController : UITableViewController

@property (strong, nonatomic) BAAppDelegate *appDelegate;
@property long selectedCellIndex;

@end
