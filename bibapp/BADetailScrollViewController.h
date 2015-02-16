//
//  BADetailScrollViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 21.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"
#import "BADetailScrollViewDelegate.h"
#import "BALocation.h"

@interface BADetailScrollViewController : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) BAAppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property BOOL pageControlUsed;
@property (strong, nonatomic) NSMutableArray *bookList;
@property (strong, nonatomic) NSMutableArray *views;
@property long scrollPosition;
@property long startPosition;
@property (strong, nonatomic) id <BADetailScrollViewDelegate> scrollViewDelegate;
@property long maximumPosition;
@property (strong, nonatomic) UIImage *tempCover;
@property (strong, nonatomic) NSMutableArray *tempTocArray;
@property (strong, nonatomic) BALocation *tempLocation;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *listButton;

- (IBAction)actionButton:(id)sender;

@end
