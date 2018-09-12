//
//  BAItemAccountCell.h
//  bibapp
//
//  Created by Johannes Schultze on 04.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAItemAccountCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *checkbox;
@property (weak, nonatomic) IBOutlet UILabel *labelLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *queueTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *queueLabel;
@property (weak, nonatomic) IBOutlet UILabel *renewalTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *renewalLabel;
@property (weak, nonatomic) IBOutlet UILabel *storageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *storageLabel;
@property (weak, nonatomic) IBOutlet UILabel *warningLabel;

@end
