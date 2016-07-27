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

-(instancetype)init {
    self = [super init];
    if (self) {
        self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

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

-(BADocumentItemElementCell *)prepareDAIAForCell:(BADocumentItemElementCell *)cell withItem:(BADocumentItem *)item withEntry:(BAEntryWork *)entry {
    if (entry.onlineLocation == nil) {
        NSMutableString *titleString = [[NSMutableString alloc] init];
        if (item.department != nil && !self.appDelegate.configuration.currentBibHideDepartment) {
            [titleString appendString:item.department];
        }
        if (item.storage != nil) {
            if (![item.storage isEqualToString:@""]) {
                if (!self.appDelegate.configuration.currentBibHideDepartment) {
                    [titleString appendFormat:@", %@", item.storage];
                } else {
                    [titleString appendFormat:@"%@", item.storage];
                }
            }
        } else {
            if (item.department != nil && [titleString isEqualToString:@""]) {
                [titleString appendString:item.department];
            }
        }
        [cell.title setText:titleString];
    } else {
        [cell.title setText:entry.onlineLocation];
    }
    [cell.subtitle setText:item.label];
    
    NSMutableString *status = [[NSMutableString alloc] init];
    NSMutableString *statusInfo = [[NSMutableString alloc] init];
    
    BADocumentItemElement *presentation;
    BADocumentItemElement *loan;
    
    for (BADocumentItemElement *element in item.services) {
        if ([element.service isEqualToString:@"presentation"]) {
            presentation = element;
        } else if ([element.service isEqualToString:@"loan"]) {
            loan = element;
        }
    }
    
    if (loan.available) {
        [cell.status setTextColor:[[UIColor alloc] initWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
        [status appendString:@"ausleihbar"];
        
        if (presentation.limitation != nil) {
            [status appendString:[[NSString alloc] initWithFormat:@"; %@", presentation.limitation]];
        }
        
        if (presentation.available) {
            if (loan.href == nil) {
                [statusInfo appendString:@"Bitte am Standort entnehmen"];
            } else {
                [statusInfo appendString:@"Bitte bestellen"];
            }
        }
    } else {
        if (loan.href != nil) {
            NSRange match = [loan.href rangeOfString: @"loan/RES"];
            if (match.length > 0) {
                [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.5 blue:0.0 alpha:1.0]];
                [status appendString:@"ausleihbar"];
            } else {
                [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.00 alpha:1.0]];
                [status appendString:@"nicht ausleihbar"];
            }
        } else {
            if (entry.onlineLocation == nil) {
                [cell.status setTextColor:[[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.00 alpha:1.0]];
                [status appendString:@"nicht ausleihbar"];
            } else {
                [status appendString:@"Online-Ressource im Browser öffnen"];
            }
        }
        if (presentation.limitation != nil) {
            [status appendString:[[NSString alloc] initWithFormat:@"; %@", presentation.limitation]];
        }
        
        if (!presentation.available) {
            if (loan.href == nil) {
                //[statusInfo appendString:@"..."];
            } else {
                NSRange match = [loan.href rangeOfString: @"loan/RES"];
                if (match.length > 0) {
                    if ([loan.expected isEqualToString:@""] || [loan.expected isEqualToString:@"unknown"]) {
                        [statusInfo appendString:@"ausgeliehen, Vormerken möglich"];
                    } else {
                        NSString *year = [loan.expected substringWithRange: NSMakeRange (0, 4)];
                        NSString *month = [loan.expected substringWithRange: NSMakeRange (5, 2)];
                        NSString *day = [loan.expected substringWithRange: NSMakeRange (8, 2)];
                        [statusInfo appendString:[[NSString alloc] initWithFormat:@"ausgeliehen bis %@.%@.%@, Vormerken möglich", day, month, year]];
                    }
                }
            }
        }
    }
    
    if (item.daiaInfoFromOpac) {
        status = [[NSMutableString alloc] initWithFormat:@"%@", self.appDelegate.configuration.currentBibDaiaInfoFromOpacDisplay];
    }
    
    [cell.status setText:status];
    [cell.statusInfo setText:statusInfo];
    
    return cell;
}

@end
