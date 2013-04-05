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
@property int scrollPosition;
@property int startPosition;
@property (strong, nonatomic) id <BADetailScrollViewDelegate> scrollViewDelegate;
@property int maximumPosition;
@property (strong, nonatomic) UIImage *tempCover;
@property (strong, nonatomic) NSMutableArray *tempTocArray;
@property (strong, nonatomic) BALocation *tempLocation;

- (IBAction)actionButton:(id)sender;

@end
