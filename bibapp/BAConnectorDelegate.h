//
//  CSConnectorDelegate.h
//  CommSy
//
//  Created by Johannes Schultze on 17.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BAConnectorDelegate <NSObject>

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result;

@end
