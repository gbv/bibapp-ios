//
//  DAIAParser.m
//  bibapp
//
//  Created by Johannes Schultze on 07.04.16.
//  Copyright © 2016 Johannes Schultze. All rights reserved.
//

#import "DAIAParser.h"
#import "GDataXMLNode.h"
#import "BADocumentItem.h"
#import "BAConnector.h"
#import "BADocumentItemElement.h"

@implementation DAIAParser

-(void)parseDAIAForDocument:(BADocument *)baDocument WithResult:(NSObject *)result {
   [baDocument setItems:[[NSMutableArray alloc] init]];
   
   NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)result options:kNilOptions error:nil];
   
   NSArray *document = [json objectForKey:@"document"];
   if ([document count] > 0) {
      if (![[[document objectAtIndex:0] objectForKey:@"id"] isEqual:[NSNull null]]) {
         [baDocument setDocumentID:[[document objectAtIndex:0] objectForKey:@"id"]];
      }
      if (![[[document objectAtIndex:0] objectForKey:@"href"] isEqual:[NSNull null]]) {
         [baDocument setHref:[[document objectAtIndex:0] objectForKey:@"href"]];
      }
   }
   
   NSDictionary *institution = [json objectForKey:@"institution"];
   if (![institution isEqual:[NSNull null]]) {
      if (![[institution objectForKey:@"content"] isEqual:[NSNull null]]) {
         [baDocument setInstitution:[institution objectForKey:@"content"]];
      }
   }
   
   BAConnector *locationConnector = [BAConnector generateConnector];
   
   NSArray *items;
   if ([document count] > 0) {
      items = [[document objectAtIndex:0] objectForKey:@"item"];
   }
   
   for (NSDictionary *item in items) {
      BADocumentItem *tempDocumentItem = [[BADocumentItem alloc] init];
      [tempDocumentItem setEdition:baDocument.documentID];
      if (![[item objectForKey:@"href"] isEqual:[NSNull null]]) {
         [tempDocumentItem setHref:[item objectForKey:@"href"]];
      }
      if (![[item objectForKey:@"id"] isEqual:[NSNull null]]) {
         [tempDocumentItem setItemID:[item objectForKey:@"id"]];
      }
      
      if (![[item objectForKey:@"label"] isEqual:[NSNull null]]) {
         [tempDocumentItem setLabel:[item objectForKey:@"label"]];
      }
      
      if (![[item objectForKey:@"department"] isEqual:[NSNull null]]) {
         NSDictionary *department = [item objectForKey:@"department"];
         [tempDocumentItem setUri:[department objectForKey:@"id"]];
         
         if (![[department objectForKey:@"id"] isEqual:[NSNull null]]) {
            [tempDocumentItem setUri:[department objectForKey:@"id"]];
            
            [tempDocumentItem setLocation:[locationConnector loadLocationForUri:[department objectForKey:@"id"]]];
            if (![tempDocumentItem.location.shortname isEqualToString:@""]) {
               [tempDocumentItem setDepartment:tempDocumentItem.location.shortname];
            } else {
               [tempDocumentItem setDepartment:tempDocumentItem.location.name];
            }
         }
      }
      
      if (![[item objectForKey:@"storage"] isEqual:[NSNull null]]) {
         NSDictionary *storage = [item objectForKey:@"storage"];
         [tempDocumentItem setStorage:[storage objectForKey:@"content"]];
      }
      
      tempDocumentItem.services = [[NSMutableArray alloc] init];
      
      NSArray *availableItems;
      if (![[item objectForKey:@"available"] isEqual:[NSNull null]]) {
         availableItems = [item objectForKey:@"available"];
         for (NSDictionary *availableItem in availableItems) {
            BADocumentItemElement *tempDocumentItemElement = [[BADocumentItemElement alloc] init];
            [tempDocumentItemElement setAvailable:YES];
            [tempDocumentItemElement setType:@"available"];
            
            if (![[availableItem objectForKey:@"href"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setHref:[availableItem objectForKey:@"href"]];
               if ([[availableItem objectForKey:@"href"] isEqualToString:@""]) {
                  [tempDocumentItemElement setOrder:NO];
               } else {
                  [tempDocumentItemElement setOrder:YES];
               }
            } else {
               [tempDocumentItemElement setOrder:NO];
            }
            
            if (![[availableItem objectForKey:@"service"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setService:[availableItem objectForKey:@"service"]];
            }
            
            if (![[availableItem objectForKey:@"delay"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setDelay:[availableItem objectForKey:@"delay"]];
            }
            
            if (![[availableItem objectForKey:@"message"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setMessage:[availableItem objectForKey:@"message"]];
            }
            
            if (![[availableItem objectForKey:@"limitation"] isEqual:[NSNull null]]) {
               NSArray *limitation = [availableItem objectForKey:@"limitation"];
               if ([limitation count] >= 1) {
                  [tempDocumentItemElement setLimitation:[[limitation objectAtIndex:0] objectForKey:@"content"]];
               }
            }
            
            if (![[availableItem objectForKey:@"expected"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setExpected:[availableItem objectForKey:@"expected"]];
            }
            
            if (![[availableItem objectForKey:@"queue"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setQueue:[availableItem objectForKey:@"queue"]];
            }
            
            [tempDocumentItem.services addObject:tempDocumentItemElement];
         }
      }

      NSArray *unavailableItems;
      if (![[item objectForKey:@"unavailable"] isEqual:[NSNull null]]) {
         unavailableItems = [item objectForKey:@"unavailable"];
         for (NSDictionary *unavailableItem in unavailableItems) {
            BADocumentItemElement *tempDocumentItemElement = [[BADocumentItemElement alloc] init];
            [tempDocumentItemElement setAvailable:NO];
            [tempDocumentItemElement setType:@"unavailable"];
            
            if (![[unavailableItem objectForKey:@"href"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setHref:[unavailableItem objectForKey:@"href"]];
               if ([[unavailableItem objectForKey:@"href"] isEqualToString:@""]) {
                  [tempDocumentItemElement setOrder:NO];
               } else {
                  [tempDocumentItemElement setOrder:YES];
               }
            } else {
               [tempDocumentItemElement setOrder:NO];
            }
            
            if (![[unavailableItem objectForKey:@"service"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setService:[unavailableItem objectForKey:@"service"]];
            }
            
            if (![[unavailableItem objectForKey:@"delay"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setDelay:[unavailableItem objectForKey:@"delay"]];
            }
            
            if (![[unavailableItem objectForKey:@"message"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setMessage:[unavailableItem objectForKey:@"message"]];
            }
            
            if (![[unavailableItem objectForKey:@"limitation"] isEqual:[NSNull null]]) {
               NSArray *limitation = [unavailableItem objectForKey:@"limitation"];
               if ([limitation count] >= 1) {
                  [tempDocumentItemElement setLimitation:[[limitation objectAtIndex:0] objectForKey:@"content"]];
               }
            }
            
            if (![[unavailableItem objectForKey:@"expected"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setExpected:[unavailableItem objectForKey:@"expected"]];
            }
            
            if (![[unavailableItem objectForKey:@"queue"] isEqual:[NSNull null]]) {
               [tempDocumentItemElement setQueue:[unavailableItem objectForKey:@"queue"]];
            }
            
            [tempDocumentItem.services addObject:tempDocumentItemElement];
         }
      }
       
      if ([availableItems count] == 0 && [unavailableItems count] == 0) {
         tempDocumentItem.daiaInfoFromOpac = YES;
      }
      
      [baDocument.items addObject:tempDocumentItem];
   }
}

@end
