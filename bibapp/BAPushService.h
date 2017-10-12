//
//  BAPushService.h
//  bibapp
//
//  Created by Johannes Schultze on 12.10.17.
//  Copyright © 2017 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BAPushService : NSObject

-(void)enablePush;
-(void)disablePush;
-(void)updatePush;

@end
