//
//  BAIdViewController.m
//  bibapp
//
//  Created by Johannes Schultze on 27.09.18.
//  Copyright © 2018 Johannes Schultze. All rights reserved.
//

#import "BAIdViewController.h"
#import "BALocalizeHelper.h"
#import "Code39.h"

@interface BAIdViewController ()

@end

@implementation BAIdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationItem setTitle:BALocalizedString(@"ID")];
    [self.navigationController.navigationBar.topItem setTitle:BALocalizedString(@"Konto")];
    
    [self.barcodeImage setImage:[Code39 code39ImageFromString:self.account Width:240 Height:70]];
    [self.barcodeLabel setText:self.account];
    [self.nameLabel setText:[self.patron objectForKey:@"name"]];
    [self.emailLabel setText:[self.patron objectForKey:@"email"]];
}

@end
