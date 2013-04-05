//
//  BATocTableViewControllerPad.h
//  bibapp
//
//  Created by Johannes Schultze on 19.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATocTableViewControllerPad : UITableViewController

@property (strong, nonatomic) NSMutableArray *tocArray;
@property (strong, nonatomic) NSString *currentToc;
@property (strong, nonatomic) UIViewController *searchController;

@end
