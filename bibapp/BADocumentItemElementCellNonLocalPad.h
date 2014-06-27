//
//  BADocumentItemElementCellNonLocalPad.h
//  bibapp
//
//  Created by Johannes Schultze on 26.02.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAConnector.h"
#import "BAConnectorDelegate.h"

@interface BADocumentItemElementCellNonLocalPad : UITableViewCell <BAConnectorDelegate>

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *labels;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) BAConnector *locationConnector;

- (void)loadLocationWithUri:(NSString *)uri;

@end
