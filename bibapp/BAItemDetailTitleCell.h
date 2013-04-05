//
//  BAItemDetailTitleCell.h
//  bibapp
//
//  Created by Johannes Schultze on 05.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAItemDetailTitleCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverView;
@property (weak, nonatomic) IBOutlet UIButton *toc;
@property (weak, nonatomic) IBOutlet UIButton *abstract;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *converIndicator;
@property (weak, nonatomic) IBOutlet UIButton *tocInfo;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *isbdIndicator;

- (IBAction)tocAction:(id)sender;
- (IBAction)abstractAction:(id)sender;
- (IBAction)coverAction:(id)sender;

@end
