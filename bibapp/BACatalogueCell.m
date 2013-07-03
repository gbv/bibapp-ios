//
//  BACatalogueCellPad.m
//  bibapp
//
//  Created by Johannes Schultze on 03.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import "BACatalogueCell.h"

@implementation BACatalogueCell

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
