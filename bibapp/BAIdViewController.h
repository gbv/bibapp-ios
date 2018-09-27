//
//  BAIdViewController.h
//  bibapp
//
//  Created by Johannes Schultze on 27.09.18.
//  Copyright © 2018 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BAIdViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (weak, nonatomic) IBOutlet UILabel *barcodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSDictionary *patron;

@end

NS_ASSUME_NONNULL_END
