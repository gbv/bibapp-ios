//
//  BATocListCell.h
//  bibapp
//
//  Created by Johannes Schultze on 26.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BATocListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tocIcon;
@property (weak, nonatomic) IBOutlet UILabel *tocLabel;

@end
