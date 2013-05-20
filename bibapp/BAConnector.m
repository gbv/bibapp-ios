//
//  SCConnector.m
//  CommSy
//
//  Created by Johannes Schultze on 16.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#include <CoreFoundation/CFURL.h>
#import "BAConnector.h"
#import "BAConnectorDelegate.h"
#import "BADocumentItem.h"
#import "BAEntryWork.h"
#import "BAURLRequestService.h"


@implementation BAConnector

static BAConnector *sharedConnector = nil;

@synthesize appDelegate;
@synthesize connectorDelegate;
@synthesize command;
@synthesize webData;
@synthesize result;
@synthesize webDataSynchronous;

+ (id)sharedConnector
{
   @synchronized(self) {
      if (sharedConnector == nil) {
         sharedConnector = [[self alloc] init];
      }
   }
   return sharedConnector;
}

+ (id)generateConnector
{
   BAConnector *connector = [[BAConnector alloc] init];
   return connector;
}

- (id)init
{
   self = [super init];
   if (self) {
      self.appDelegate = (BAAppDelegate *)[[UIApplication sharedApplication] delegate];
   }
   return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   webData = [[NSMutableData alloc] init];
	[webData setLength: 0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   [webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   [connectorDelegate command:[self command] didFinishLoadingWithResult:webData];
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
   return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    // Add trusted hosts to this array in order to handle authentication challenges
   NSMutableArray* trustedHosts = [NSMutableArray array];
   if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] &&
       [trustedHosts containsObject:challenge.protectionSpace.host])
   {
         [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
   }
   else
   {
       [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
   }

}

- (void)searchLocalFor:(NSString *)term WithFirst:(int)first WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"searchLocal"];
   term = [self encodeToPercentEscapeString:term];
   term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];
   term = [term stringByReplacingOccurrencesOfString:@"%2A" withString:@"*"];
   term = [term stringByReplacingOccurrencesOfString:@"%3F" withString:@"*"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://sru.gbv.de/%@?version=1.1&operation=searchRetrieve&query=pica.all=%@+or+pica.tmb=%@+not+(pica.mak=ac*+or+pica.mak=bc*+or+pica.mak=ec*+or+pica.mak=gc*+or+pica.mak=kc*+or+pica.mak=mc*+or+pica.mak=oc*+or+pica.mak=sc*+or+pica.mak=ad*)&startRecord=%d&maximumRecords=%@&recordSchema=mods", self.appDelegate.configuration.currentBibLocalSearchURL, term, term, first, self.appDelegate.configuration.currentBibSearchMaximumRecords]];
   
   NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)searchCentralFor:(NSString *)term WithFirst:(int)first WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"searchLocal"];
   term = [self encodeToPercentEscapeString:term];
   term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];
   term = [term stringByReplacingOccurrencesOfString:@"%2A" withString:@"*"];
   term = [term stringByReplacingOccurrencesOfString:@"%3F" withString:@"*"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://sru.gbv.de/gvk?version=1.1&operation=searchRetrieve&query=pica.all=%@+or+pica.tmb=%@+not+(pica.mak=ac*+or+pica.mak=bc*+or+pica.mak=ec*+or+pica.mak=gc*+or+pica.mak=kc*+or+pica.mak=mc*+or+pica.mak=oc*+or+pica.mak=sc*+or+pica.mak=ad*)&startRecord=%d&maximumRecords=%@&recordSchema=mods", term, term, first, self.appDelegate.configuration.currentBibSearchMaximumRecords]];
   
   NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)getUNAPIDetailsFor:(NSString *)ppn WithFormat:(NSString *)format WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:[NSString stringWithFormat:@"getUNAPIDetails%@", [format capitalizedString]]];
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://unapi.gbv.de/?id=gvk:ppn:%@&format=%@", ppn, format]];
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:url];
	
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)getDetailsForLocal:(NSString *)ppn WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getDetailsLocal"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?id=ppn:%@&format=xml", self.appDelegate.configuration.currentBibDetailURL, ppn]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)getDetailsFor:(NSString *)ppn WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getDetails"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://daia.gbv.de/?id=gvk:ppn:%@&format=xml", ppn]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)getCoverFor:(NSString *)number WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getCover"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://ws.gbv.de/covers/?id=%@&format=img", number]];
   NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)loginWithAccount:(NSString *)account WithPassword:(NSString *)password WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"login"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/auth/login?username=%@&password=%@&grant_type=password", self.appDelegate.configuration.currentBibPAIAURL, account, password]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)accountLoadLoanListWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountLoadLoanList"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/items?access_token=%@", self.appDelegate.configuration.currentBibPAIAURL, account, token]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)accountLoadReservedListWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
}

- (void)accountLoadFeesWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountLoadFees"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/fees?access_token=%@", self.appDelegate.configuration.currentBibPAIAURL, account, token]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)accountLoadPatronWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountLoadPatron"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@?access_token=%@", self.appDelegate.configuration.currentBibPAIAURL, account, token]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)accountLoadInterloanWithAccount:(NSString *)account ListWithToken:(NSString *)token WithDelegate:(id)delegate
{
   [delegate command:@"accountLoadInterloanList" didFinishLoadingWithResult:token];
}

- (void)accountRequestDocs:(NSArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountRequestDocs"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/request?access_token=%@", self.appDelegate.configuration.currentBibPAIAURL, account, token]];
	
   NSMutableString*jsonString = [[NSMutableString alloc] init];
   [jsonString appendString:@"["];

   for (BADocumentItem *tempDocumentItem in docs) {
      
      if (![tempDocumentItem isEqual:[docs lastObject]] && docs.count != 1)
      {
         [jsonString appendString:@","];
      }
      
      NSDictionary *tempDocumentDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempDocumentItem.itemID, @"item", tempDocumentItem.edition, @"edition", nil];
      NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempDocumentDict options:NSJSONWritingPrettyPrinted error:nil];
      NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
      
      [jsonString appendString:tempString];
   }
   [jsonString appendString:@"]"];
   
   NSUInteger contentLength = [jsonString length];
   NSData *body = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] postRequestWithURL:url HTTPBody:body contentLength:contentLength];
   
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)accountRenewDocs:(NSArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountRenewDocs"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/renew?access_token=%@", self.appDelegate.configuration.currentBibPAIAURL, account, token]];
	
   NSMutableString*jsonString = [[NSMutableString alloc] init];
   [jsonString appendString:@"["];

   for (BAEntryWork *tempEntry in docs) {
      
      if (![tempEntry isEqual:[docs lastObject]] && docs.count != 1)
      {
         [jsonString appendString:@","];
      }
      
      NSDictionary *tempEntryDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempEntry.item, @"item", tempEntry.edition, @"edition", tempEntry.bar, @"barcode", nil];
      NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempEntryDict options:NSJSONWritingPrettyPrinted error:nil];
      NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
      [jsonString appendString:tempString];
   }
   [jsonString appendString:@"]"];
   
   NSUInteger contentLength = [jsonString length];
   NSData *body = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] postRequestWithURL:url HTTPBody:body contentLength:contentLength];
   
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)accountCancelDocs:(NSArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountCancelDocs"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/cancel?access_token=%@", self.appDelegate.configuration.currentBibPAIAURL, account, token]];
	
   NSMutableString*jsonString = [[NSMutableString alloc] init];
   [jsonString appendString:@"["];

   for (BAEntryWork *tempEntry in docs) {
      
      if (![tempEntry isEqual:[docs lastObject]] && docs.count != 1)
      {
         [jsonString appendString:@","];
      }
      
      NSDictionary *tempEntryDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempEntry.item, @"item", tempEntry.edition, @"edition", tempEntry.bar, @"barcode", nil];
      NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempEntryDict options:NSJSONWritingPrettyPrinted error:nil];
      NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
      [jsonString appendString:tempString];
   }
   [jsonString appendString:@"]"];
   
   NSUInteger contentLength = [jsonString length];
   NSData *body = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
   NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] postRequestWithURL:url HTTPBody:body contentLength:contentLength];
   
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)getInfoFeedWithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getInfoFeedWithDelegate"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", self.appDelegate.configuration.currentBibFeedURL]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)getLocationInfoForUri:(NSString *)uri WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getLocationInfoForUri"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?format=json", uri]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (void)getLocationsForLibraryByUri:(NSString *)uri WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getLocationsForLibraryByUri"];
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?format=json", uri]];
	NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
   NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
   if (theConnection) {
   }
}

- (BALocation *)loadLocationForUri:(NSString *)uri
{
   BALocation *resultLocation;
   BOOL foundInCache = NO;
   
   NSEntityDescription *entityDescriptionLocations = [NSEntityDescription entityForName:@"BALocation" inManagedObjectContext:[self.appDelegate managedObjectContext]];
   NSFetchRequest *requestLocation = [[NSFetchRequest alloc] init];
   [requestLocation setEntity:entityDescriptionLocations];
   NSError *error = nil;
   [self.appDelegate setLocations:[[self.appDelegate.managedObjectContext executeFetchRequest:requestLocation error:&error] mutableCopy]];
   
   for (BALocation *tempLocation in self.appDelegate.locations) {
      if ([uri isEqualToString:tempLocation.uri]) {
         NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:tempLocation.timestamp];
         if (secondsBetween < 604800) {
            resultLocation = tempLocation;
            foundInCache = YES;
         } else {
            [self.appDelegate.managedObjectContext deleteObject:tempLocation];
            NSError *error = nil;
            if (![[appDelegate managedObjectContext] save:&error]) {
               // Handle the error.
            }
         }
      }
   }
   
   if (!foundInCache) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?format=json", uri]];
      if ([NSData dataWithContentsOfURL:url] != nil) {
         BALocation *newLocation = (BALocation *)[NSEntityDescription insertNewObjectForEntityForName:@"BALocation" inManagedObjectContext:[self.appDelegate managedObjectContext]];
         [newLocation setUri:uri];
         [newLocation setTimestamp:[NSDate date]];
         BOOL foundName = NO;
         BOOL foundShortname = NO;
         BOOL foundAddress = NO;
         BOOL foundOpeningHours = NO;
         BOOL foundEmail = NO;
         BOOL foundUrl = NO;
         BOOL foundPhone = NO;
         BOOL foundGeoLong = NO;
         BOOL foundGeoLat = NO;
         BOOL foundDesc = NO;
         NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)[NSData dataWithContentsOfURL:url] options:kNilOptions error:nil];
         
         for (NSString *key in [json objectForKey:uri]) {
            if ([key isEqualToString:@"http://xmlns.com/foaf/0.1/name"]) {
               [newLocation setName:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0]objectForKey:@"value"]];
               foundName = YES;
            }
            if ([key isEqualToString:@"http://dbpedia.org/property/shortName"]) {
               [newLocation setShortname:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0]objectForKey:@"value"]];
               foundShortname = YES;
            }
            if ([key isEqualToString:@"http://purl.org/ontology/gbv/address"]) {
               [newLocation setAddress:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0]objectForKey:@"value"]];
               foundAddress = YES;
            }
            if ([key isEqualToString:@"http://purl.org/ontology/gbv/openinghours"]) {
               [newLocation setOpeninghours:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0]objectForKey:@"value"]];
               foundOpeningHours = YES;
            }
            if ([key isEqualToString:@"http://www.w3.org/2006/vcard/ns#email"]) {
               [newLocation setEmail:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0]objectForKey:@"value"]];
               foundEmail = YES;
            }
            if ([key isEqualToString:@"http://www.w3.org/2006/vcard/ns#url"]) {
               [newLocation setUrl:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0]objectForKey:@"value"]];
               foundUrl = YES;
            }
            if ([key isEqualToString:@"http://xmlns.com/foaf/0.1/phone"]) {
               [newLocation setPhone:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0]objectForKey:@"value"]];
               foundPhone = YES;
            }
            if ([key isEqualToString:@"http://www.w3.org/2003/01/geo/wgs84_pos#location"]) {
               NSString *tempKey = [[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0] objectForKey:@"value"];
               for (NSString *keyGeo in [json objectForKey:tempKey]) {
                  if ([keyGeo isEqualToString:@"http://www.w3.org/2003/01/geo/wgs84_pos#long"]) {
                     [newLocation setGeoLong:[[[[json objectForKey:tempKey] objectForKey:keyGeo] objectAtIndex:0]objectForKey:@"value"]];
                     foundGeoLong = YES;
                  }
                  if ([keyGeo isEqualToString:@"http://www.w3.org/2003/01/geo/wgs84_pos#lat"]) {
                     [newLocation setGeoLat:[[[[json objectForKey:tempKey] objectForKey:keyGeo] objectAtIndex:0]objectForKey:@"value"]];
                     foundGeoLat = YES;
                  }
               }
            }
            if ([key isEqualToString:@"http://purl.org/dc/elements/1.1/description"]) {
               [newLocation setDesc:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:0]objectForKey:@"value"]];
               foundDesc = YES;
            }
         }
         if (!foundName) {
            [newLocation setName:@""];
         }
         if (!foundShortname) {
            [newLocation setShortname:@""];
         }
         if (!foundGeoLong) {
            [newLocation setGeoLong:@""];
         }
         if (!foundGeoLat) {
            [newLocation setGeoLat:@""];
         }
         if (!foundAddress) {
            [newLocation setAddress:@""];
         }
         if (!foundOpeningHours) {
            [newLocation setOpeninghours:@""];
         }
         if (!foundEmail) {
            [newLocation setEmail:@""];
         }
         if (!foundUrl) {
            [newLocation setUrl:@""];
         }
         if (!foundPhone) {
            [newLocation setPhone:@""];
         }
         if( !foundDesc) {
            [newLocation setDesc:@""];
         }
         
         NSError *error = nil;
         if (![[self.appDelegate managedObjectContext] save:&error]) {
            // Handle the error.
         }
         
         resultLocation = newLocation;
      }
   }
   return resultLocation;
}

- (NSString*)encodeToPercentEscapeString:(NSString *)string
{
   NSString *returnString = CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                      (CFStringRef) string,
                                                                                      NULL,
                                                                                      (CFStringRef) @"!*'();:@&=+$,/?%#[]",
                                                                                      kCFStringEncodingUTF8));
   return returnString;
}

- (NSString*)decodeFromPercentEscapeString:(NSString *)string
{
   NSString *returnString = CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                      (CFStringRef) string,
                                                                                                      CFSTR(""),
                                                                                                      kCFStringEncodingUTF8));
   return returnString;
}

@end
