//
//  BATocListCell.m
//  bibapp
//
//  Created by Johannes Schultze on 26.03.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BATocListCell.h"

@implementation BATocListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
