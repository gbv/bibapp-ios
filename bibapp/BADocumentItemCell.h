//
//  BADocumentItemCell.h
//  bibapp
//
//  Created by Johannes Schultze on 29.11.12.
//  Copyright (c) 2012 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BADocumentItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@end
