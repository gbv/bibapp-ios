//
//  BAItemDetailTitleCell.m
//  bibapp
//
//  Created by Johannes Schultze on 05.12.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import "BAItemDetailTitleCell.h"

@implementation BAItemDetailTitleCell

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

- (IBAction)tocAction:(id)sender
{
}

- (IBAction)abstractAction:(id)sender
{
}

- (IBAction)coverAction:(id)sender
{

}

@end
