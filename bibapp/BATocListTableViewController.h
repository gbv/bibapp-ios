//
//  BATocListTableViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 26.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATocListTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *tocArray;
@property (strong, nonatomic) NSString *currentToc;

@end
