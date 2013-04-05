//
//  BAItemDetailCell.m
//  bibapp
//
//  Created by Johannes Schultze on 30.10.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAItemDetailCell.h"

@implementation BAItemDetailCell

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
