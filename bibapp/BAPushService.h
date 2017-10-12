//
//  BAPushService.h
//  bibapp
//
//  Created by Johannes Schultze on 12.10.17.
//  Copyright © 2017 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAConnectorDelegate.h"

@class BAAppDelegate;

@interface BAPushService : NSObject <BAConnectorDelegate>

@property (strong, nonatomic) BAAppDelegate *appDelegate;

-(void)enablePush;
-(void)disablePush;
-(void)updatePush;

@end
