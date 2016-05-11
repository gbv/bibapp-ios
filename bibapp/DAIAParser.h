//
//  DAIAParser.h
//  bibapp
//
//  Created by Johannes Schultze on 07.04.16.
//  Copyright © 2016 Johannes Schultze. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BADocument.h"

@interface DAIAParser : NSObject

-(void)parseDAIAForDocument:(BADocument *)baDocument WithResult:(NSObject *)data;

@end
