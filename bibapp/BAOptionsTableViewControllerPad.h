//
//  BAOptionsTableViewControllerPad.h
//  bibapp
//
//  Created by Johannes Schultze on 02.07.13.
//  Copyright (c) 2013 Johannes Schultze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAAppDelegate.h"
#import "BAConnectorDelegate.h"

@interface BAOptionsTableViewControllerPad : UITableViewController <BAConnectorDelegate>

@property(strong, nonatomic) BAAppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UISwitch *saveLocalSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *countPixelSwitch;
@property (weak, nonatomic) IBOutlet UILabel *catalogueLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UISwitch *pushButton;

- (IBAction)saveLocalSwitchAction:(id)sender;
- (IBAction)countPixelSwitchAction:(id)sender;
- (IBAction)logoutAction:(id)sender;
- (IBAction)pushAction:(id)sender;

@end
