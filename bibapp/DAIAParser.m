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
   GDataXMLDocument *parser = [[GDataXMLDocument alloc] initWithData:(NSData *)result options:0 error:nil];
   NSArray *document = [parser nodesForXPath:@"_def_ns:daia/_def_ns:document" error:nil];
   if ([document count] > 0) {
      GDataXMLElement *tempDocument = [document objectAtIndex:0];
      [baDocument setDocumentID:[[tempDocument attributeForName:@"id"] stringValue]];
      [baDocument setHref:[[tempDocument attributeForName:@"href"] stringValue]];
   }
   
   NSArray *institution = [parser nodesForXPath:@"_def_ns:daia/_def_ns:institution" error:nil];
   if ([institution count] > 0) {
      GDataXMLElement *tempInstitution = [institution objectAtIndex:0];
      [baDocument setInstitution:[tempInstitution stringValue]];
   }
   
   BAConnector *locationConnector = [BAConnector generateConnector];
   NSArray *items = [parser nodesForXPath:@"_def_ns:daia/_def_ns:document/_def_ns:item" error:nil];
   for (GDataXMLElement *item in items) {
      BADocumentItem *tempDocumentItem = [[BADocumentItem alloc] init];
      [tempDocumentItem setEdition:baDocument.documentID];
      [tempDocumentItem setHref:[[item attributeForName:@"href"] stringValue]];
      [tempDocumentItem setItemID:[[item attributeForName:@"id"] stringValue]];
      
      NSArray *label = [item elementsForName:@"label"];
      if ([label count] == 1) {
         [tempDocumentItem setLabel:[[label objectAtIndex:0] stringValue]];
      }
      
      NSArray *department = [item elementsForName:@"department"];
      if ([department count] == 1) {
         [tempDocumentItem setUri:[[[department objectAtIndex:0] attributeForName:@"id"] stringValue]];
         [tempDocumentItem setLocation:[locationConnector loadLocationForUri:[[[department objectAtIndex:0] attributeForName:@"id"] stringValue]]];
         if (![tempDocumentItem.location.shortname isEqualToString:@""]) {
            [tempDocumentItem setDepartment:tempDocumentItem.location.shortname];
         } else {
            [tempDocumentItem setDepartment:tempDocumentItem.location.name];
         }
      }
      
      NSArray *storage = [item elementsForName:@"storage"];
      if ([storage count] == 1) {
         [tempDocumentItem setStorage:[[storage objectAtIndex:0] stringValue]];
      }
      
      tempDocumentItem.services = [[NSMutableArray alloc] init];
      NSArray *availableItems = [item elementsForName:@"available"];
      for (GDataXMLElement *availableItem in availableItems) {
         BADocumentItemElement *tempDocumentItemElement = [[BADocumentItemElement alloc] init];
         [tempDocumentItemElement setAvailable:YES];
         [tempDocumentItemElement setType:@"available"];
         [tempDocumentItemElement setHref:[[availableItem attributeForName:@"href"] stringValue]];
         if ([[[availableItem attributeForName:@"href"] stringValue] isEqualToString:@""] || [[availableItem attributeForName:@"href"] stringValue] == nil) {
            [tempDocumentItemElement setOrder:NO];
         } else {
            [tempDocumentItemElement setOrder:YES];
         }
         [tempDocumentItemElement setService:[[availableItem attributeForName:@"service"] stringValue]];
         [tempDocumentItemElement setDelay:[[availableItem attributeForName:@"delay"] stringValue]];
         [tempDocumentItemElement setMessage:[[availableItem attributeForName:@"message"] stringValue]];
         
         NSArray *limitation = [availableItem elementsForName:@"limitation"];
         if ([limitation count] == 1) {
            [tempDocumentItemElement setLimitation:[[limitation objectAtIndex:0] stringValue]];
         }
         
         [tempDocumentItemElement setExpected:[[availableItem attributeForName:@"expected"] stringValue]];
         [tempDocumentItemElement setQueue:[[availableItem attributeForName:@"queue"] stringValue]];
         [tempDocumentItem.services addObject:tempDocumentItemElement];
      }
      tempDocumentItem.unavailable = [[NSMutableArray alloc] init];
      NSArray *unavailableItems = [item elementsForName:@"unavailable"];
      for (GDataXMLElement *unavailableItem in unavailableItems) {
         BADocumentItemElement *tempDocumentItemElement = [[BADocumentItemElement alloc] init];
         [tempDocumentItemElement setAvailable:NO];
         [tempDocumentItemElement setType:@"unavailable"];
         [tempDocumentItemElement setHref:[[unavailableItem attributeForName:@"href"] stringValue]];
         if ([[[unavailableItem attributeForName:@"href"] stringValue] isEqualToString:@""] || [[unavailableItem attributeForName:@"href"] stringValue] == nil) {
            [tempDocumentItemElement setOrder:NO];
         } else {
            [tempDocumentItemElement setOrder:YES];
         }
         [tempDocumentItemElement setService:[[unavailableItem attributeForName:@"service"] stringValue]];
         [tempDocumentItemElement setDelay:[[unavailableItem attributeForName:@"delay"] stringValue]];
         [tempDocumentItemElement setMessage:[[unavailableItem attributeForName:@"message"] stringValue]];
         [tempDocumentItemElement setLimitation:[[unavailableItem attributeForName:@"limitation"] stringValue]];
         [tempDocumentItemElement setExpected:[[unavailableItem attributeForName:@"expected"] stringValue]];
         [tempDocumentItemElement setQueue:[[unavailableItem attributeForName:@"queue"] stringValue]];
         [tempDocumentItem.services addObject:tempDocumentItemElement];
      }
      
      if ([availableItems count] == 0 && [unavailableItems count] == 0) {
         tempDocumentItem.daiaInfoFromOpac = YES;
      }
      
      [baDocument.items addObject:tempDocumentItem];
   }
}

@end
