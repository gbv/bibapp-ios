//
//  BADocumentItemElementCell.h
//  bibapp
//
//  Created by Johannes Schultze on 29.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BADocumentItemElementCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *imageLoan;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorLoan;
@property (weak, nonatomic) IBOutlet UIImageView *imagePresentation;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorPresentation;
@property (weak, nonatomic) IBOutlet UIImageView *imageInterloan;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorInterloan;
@property (weak, nonatomic) IBOutlet UIImageView *imageOpenAccess;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorOpenAccess;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *statusInfo;

@end
