//
//  BAAccountTableHeaderViewPad.h
//  bibapp
//
//  Created by Johannes Schultze on 21.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BAAccountTableHeaderViewPad : UIView

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
