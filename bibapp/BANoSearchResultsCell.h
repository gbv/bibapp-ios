//
//  BANoSearchResultsCell.h
//  bibapp
//
//  Created by Johannes Schultze on 21.07.15.
//  Copyright (c) 2015 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BANoSearchResultsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *searchGBVButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
