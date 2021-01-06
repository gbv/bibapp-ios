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
#import "BAConfiguration.h"

@implementation BAConnector

NSString *const ERROR_MESSAGE_SCOPE = @"Ihr Konto ist für diesen Vorgang gesperrt.";
NSString *const ERROR_MESSAGE_NETWORK_REACHABILITY = @"Keine Internetverbindung verfügbar.";

static BAConnector *sharedConnector = nil;

@synthesize appDelegate;
@synthesize connectorDelegate;
@synthesize command;
@synthesize webData;
@synthesize result;
@synthesize webDataSynchronous;
@synthesize currentConnection;
@synthesize baseURL;

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
       self.urlencodeCharacters = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   @"%2C",          @",",
                                   @"%3B",          @";",
                                   @".",            @".",
                                   @"%3A",          @":",
                                   @"%E2%80%93",    @"–",
                                   @"_",            @"_",
                                   @"%23",          @"#",
                                   @"%E2%80%99",    @"’",
                                   @"%2B",          @"+",
                                   @"%2A",          @"*",
                                   @"%21",          @"!",
                                   @"%E2%80%9C",    @"“",
                                   @"%24",          @"$",
                                   @"%25",          @"%",
                                   @"%26",          @"&",
                                   @"%2F",          @"/",
                                   @"%28",          @"(",
                                   @"%29",          @")",
                                   @"%3D",          @"=",
                                   @"%3F",          @"?",
                                   nil];
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
    //NSLog(@"%@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   if ([command isEqualToString:@"loadLocationForUri"]) {
      [connectorDelegate command:[self command] didFinishLoadingWithResult:[self parseLocation:webData ForUri:self.baseURL]];
   } else {
      [connectorDelegate command:[self command] didFinishLoadingWithResult:webData];
   }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    completionHandler(NSURLSessionResponseAllow);
    webData = [[NSMutableData alloc] init];
    [webData setLength: 0];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [webData appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    } else {
        if ([command isEqualToString:@"loadLocationForUri"]) {
           [connectorDelegate command:[self command] didFinishLoadingWithResult:[self parseLocation:webData ForUri:self.baseURL]];
        } else {
           [connectorDelegate command:[self command] didFinishLoadingWithResult:webData];
        }
    }
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    // Add trusted hosts to this array in order to handle authentication challenges
    NSMutableArray* trustedHosts = [NSMutableArray array];

    [trustedHosts addObject:@"paia-hawk.effective-webwork.de"];
    [trustedHosts addObject:@"paia-hawk-9.effective-webwork.de"];
    [trustedHosts addObject:@"paia-hawk-4.effective-webwork.de"];
    [trustedHosts addObject:@"paia-hawk-3.effective-webwork.de"];
    [trustedHosts addObject:@"paia-hawk-2.effective-webwork.de"];
    [trustedHosts addObject:@"paia-hawk-1.effective-webwork.de"];
    [trustedHosts addObject:@"aezb.api.effective-webwork.de"];
     
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

- (void)searchLocalFor:(NSString *)term WithFirst:(long)first WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"searchLocal"];
   if ([self checkNetworkReachability]) {
      term = [self encodeToPercentEscapeString:term];
      term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];
      term = [term stringByReplacingOccurrencesOfString:@"%2A" withString:@"*"];
      term = [term stringByReplacingOccurrencesOfString:@"%3F" withString:@"*"];
      //NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://sru.k10plus.de/%@?version=1.1&operation=searchRetrieve&query=pica.all=%@+or+pica.tmb=%@+not+(pica.bbg=ac*+or+pica.bbg=bc*+or+pica.bbg=ec*+or+pica.bbg=gc*+or+pica.bbg=kc*+or+pica.bbg=mc*+or+pica.bbg=oc*+or+pica.bbg=sc*+or+pica.bbg=ad*)&startRecord=%d&maximumRecords=%@&recordSchema=mods", self.appDelegate.configuration.currentBibLocalSearchURL, term, term, first, self.appDelegate.configuration.currentBibSearchMaximumRecords]];
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://sru.k10plus.de/%@?version=1.1&operation=searchRetrieve&query=pica.all=%@+or+pica.tmb=%@+not+(pica.bbg=ac*+or+pica.bbg=bc*+or+pica.bbg=ec*+or+pica.bbg=gc*+or+pica.bbg=kc*+or+pica.bbg=mc*+or+pica.bbg=oc*+or+pica.bbg=sc*+or+pica.bbg=ad*)&startRecord=%ld&maximumRecords=%@&recordSchema=mods", [self.appDelegate.configuration getURLForCatalog:self.appDelegate.options.selectedCatalogue], term, term, first, self.appDelegate.configuration.currentBibSearchMaximumRecords]];
       
      [self resumeTaskWithUrl:url];
       
      if (first == 1) {
          if (self.appDelegate.options.allowCountPixel) {
              BAConnector *searchCountConnector = [BAConnector generateConnector];
              [searchCountConnector searchCountWithDelegate:self];
          }
      }
   }
}

-(void)searchLocalFor:(NSString *)term WithPicaParameter:(NSString *)picaParameter WithFirst:(long)first WithDelegate:(id)delegate {
    [self setConnectorDelegate:delegate];
    [self setCommand:@"searchLocal"];
    if ([self checkNetworkReachability]) {
        term = [self encodeToPercentEscapeString:term];
        term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        term = [term stringByReplacingOccurrencesOfString:@"%2A" withString:@"*"];
        term = [term stringByReplacingOccurrencesOfString:@"%3F" withString:@"*"];
        //NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://sru.k10plus.de/%@?version=1.1&operation=searchRetrieve&query=pica.all=%@+or+pica.tmb=%@+not+(pica.bbg=ac*+or+pica.bbg=bc*+or+pica.bbg=ec*+or+pica.bbg=gc*+or+pica.bbg=kc*+or+pica.bbg=mc*+or+pica.bbg=oc*+or+pica.bbg=sc*+or+pica.bbg=ad*)&startRecord=%d&maximumRecords=%@&recordSchema=mods", self.appDelegate.configuration.currentBibLocalSearchURL, term, term, first, self.appDelegate.configuration.currentBibSearchMaximumRecords]];
        NSString *urlString = [NSString stringWithFormat:@"https://sru.k10plus.de/%@?version=1.1&operation=searchRetrieve&query=pica.all=%@+or+pica.tmb=%@+not+(pica.bbg=ac*+or+pica.bbg=bc*+or+pica.bbg=ec*+or+pica.bbg=gc*+or+pica.bbg=kc*+or+pica.bbg=mc*+or+pica.bbg=oc*+or+pica.bbg=sc*+or+pica.bbg=ad*)&startRecord=%ld&maximumRecords=%@&recordSchema=mods", [self.appDelegate.configuration getURLForCatalog:self.appDelegate.options.selectedCatalogue], term, term, first, self.appDelegate.configuration.currentBibSearchMaximumRecords];
        urlString = [urlString stringByReplacingOccurrencesOfString:@"pica.bbg" withString:picaParameter];
        NSURL *url = [NSURL URLWithString: urlString];
        
        [self resumeTaskWithUrl:url];
        
        if (first == 1) {
            if (self.appDelegate.options.allowCountPixel) {
                BAConnector *searchCountConnector = [BAConnector generateConnector];
                [searchCountConnector searchCountWithDelegate:self];
            }
        }
    }
}

- (void)searchCountWithDelegate:(id)delegate
{
    if (![[self.appDelegate.configuration getSearchCountURLForCatalog:self.appDelegate.options.selectedCatalogue] isEqualToString:@""]) {
        [self setConnectorDelegate:delegate];
        [self setCommand:@"searchCount"];
        if ([self checkNetworkReachability]) {
           NSURL *url = [NSURL URLWithString:[self.appDelegate.configuration getSearchCountURLForCatalog:self.appDelegate.options.selectedCatalogue]];
           NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
           [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
           [theRequest setHTTPMethod:@"GET"];
           [self resumeTaskWithUrl:url];
        }
    }
}


- (void)searchCentralFor:(NSString *)term WithFirst:(long)first WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"searchCentral"];
   if ([self checkNetworkReachability]) {
      term = [self encodeToPercentEscapeString:term];
      term = [term stringByReplacingOccurrencesOfString:@" " withString:@"+"];
      term = [term stringByReplacingOccurrencesOfString:@"%2A" withString:@"*"];
      term = [term stringByReplacingOccurrencesOfString:@"%3F" withString:@"*"];
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://sru.k10plus.de/gvk?version=1.1&operation=searchRetrieve&query=pica.all=%@+or+pica.tmb=%@+not+(pica.bbg=ac*+or+pica.bbg=bc*+or+pica.bbg=ec*+or+pica.bbg=gc*+or+pica.bbg=kc*+or+pica.bbg=mc*+or+pica.bbg=oc*+or+pica.bbg=sc*+or+pica.bbg=ad*)&startRecord=%ld&maximumRecords=%@&recordSchema=mods", term, term, first, self.appDelegate.configuration.currentBibSearchMaximumRecords]];
      
      NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
      NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
      NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
      NSURLSessionDataTask *task = [session dataTaskWithRequest:theRequest];
      [task resume];
   }
}

- (void)getUNAPIDetailsFor:(NSString *)ppn WithFormat:(NSString *)format WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:[NSString stringWithFormat:@"getUNAPIDetails%@", [format capitalizedString]]];
   //if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://unapi.k10plus.de/?id=gvk:ppn:%@&format=%@", ppn, format]];
      [self resumeTaskWithUrl:url];
   //}
}

- (void)getDetailsForLocal:(NSString *)ppn WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getDetailsLocal"];
   if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?id=ppn:%@&format=json", [self.appDelegate.configuration getDetailURLForCatalog:self.appDelegate.options.selectedCatalogue], ppn]];
      [self resumeTaskWithUrl:url];
   }
}

- (void)getDetailsFor:(NSString *)ppn WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getDetails"];
   if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://daia.gbv.de/?id=gvk:ppn:%@&format=json", ppn]];
      [self resumeTaskWithUrl:url];
   }
}

- (void)getCoverFor:(NSString *)number WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getCover"];
   //if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"http://ws.gbv.de/covers/?id=%@&format=img", number]];
      [self resumeTaskWithUrl:url];
   //}
}

- (void)loginWithAccount:(NSString *)account WithPassword:(NSString *)password WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"login"];
   if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/auth/login?username=%@&password=%@&grant_type=password", [self.appDelegate.configuration getPAIAURLForCatalog:self.appDelegate.options.selectedCatalogue], [self urlencodeString:account], [self urlencodeString:password]]];
      [self resumeTaskWithUrl:url];
   }
}

-(void)logoutWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate {
   [self setConnectorDelegate:delegate];
   [self setCommand:@"logout"];
   if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/auth/logout?patron=%@&access_token=%@", [self.appDelegate.configuration getPAIAURLForCatalog:self.appDelegate.options.selectedCatalogue], [self urlencodeString:account], token]];
      [self resumeTaskWithUrl:url];
   }
}

- (void)accountLoadLoanListWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountLoadLoanList"];
   if ([self checkNetworkReachability]) {
      if ([self checkScope:@"read_items"]) {
         NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/items?access_token=%@", [self.appDelegate.configuration getPAIAURLForCatalog:self.appDelegate.options.selectedCatalogue], [self urlencodeString:account], token]];
         [self resumeTaskWithUrl:url];
      } else {
         [self displayError];
      }
   }
}

- (void)accountLoadReservedListWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
}

- (void)accountLoadFeesWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountLoadFees"];
   if ([self checkNetworkReachability]) {
      if ([self checkScope:@"read_fees"]) {
         NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/fees?access_token=%@", [self.appDelegate.configuration getPAIAURLForCatalog:self.appDelegate.options.selectedCatalogue], [self urlencodeString:account], token]];
         [self resumeTaskWithUrl:url];
      } else {
         [self displayError];
      }
   }
}

- (void)accountLoadPatronWithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountLoadPatron"];
   if ([self checkNetworkReachability]) {
      if ([self checkScope:@"read_patron"]) {
         NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@?access_token=%@", [self.appDelegate.configuration getPAIAURLForCatalog:self.appDelegate.options.selectedCatalogue], [self urlencodeString:account], token]];
         [self resumeTaskWithUrl:url];
      } else {
         [self displayError];
      }
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
   if ([self checkNetworkReachability]) {
      if ([self checkScope:@"write_items"]) {
         NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/request?access_token=%@", [self.appDelegate.configuration getPAIAURLForCatalog:self.appDelegate.options.selectedCatalogue], [self urlencodeString:account], token]];
         NSMutableString*jsonString = [[NSMutableString alloc] init];
         if ([self.appDelegate.configuration usePAIAWrapper]) {
            [jsonString appendString:@"["];
         } else {
            [jsonString appendString:@"{\"doc\":["];
         }
         for (BADocumentItem *tempDocumentItem in docs) {
            if (![self.appDelegate.configuration usePAIAWrapper]) {
               NSDictionary *tempDocumentDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempDocumentItem.itemID, @"item", tempDocumentItem.edition, @"edition", nil];
               NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempDocumentDict options:NSJSONWritingPrettyPrinted error:nil];
               NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
               [jsonString appendString:tempString];
            }
            if (![tempDocumentItem isEqual:[docs lastObject]] && docs.count != 1)
            {
               [jsonString appendString:@","];
            }
            if ([self.appDelegate.configuration usePAIAWrapper]) {
               NSDictionary *tempDocumentDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempDocumentItem.itemID, @"item", tempDocumentItem.edition, @"edition", nil];
               NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempDocumentDict options:NSJSONWritingPrettyPrinted error:nil];
               NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
               [jsonString appendString:tempString];
            }
         }
         if ([self.appDelegate.configuration usePAIAWrapper]) {
            [jsonString appendString:@"]"];
         } else {
            [jsonString appendString:@"]}"];
         }
         NSUInteger contentLength = [jsonString length];
         NSData *body = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
         NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] postRequestWithURL:url HTTPBody:body contentLength:contentLength];
         
         NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
         NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
         NSURLSessionDataTask *task = [session dataTaskWithRequest:theRequest];
         [task resume];
      } else {
         [self displayError];
      }
   }
}

- (void)accountRenewDocs:(NSArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountRenewDocs"];
   if ([self checkNetworkReachability]) {
      if ([self checkScope:@"write_items"]) {
         NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/renew?access_token=%@", [self.appDelegate.configuration getPAIAURLForCatalog:self.appDelegate.options.selectedCatalogue], [self urlencodeString:account], token]];
         NSMutableString*jsonString = [[NSMutableString alloc] init];
         if ([self.appDelegate.configuration usePAIAWrapper]) {
            [jsonString appendString:@"["];
         } else {
            [jsonString appendString:@"{\"doc\":["];
         }
         for (BAEntryWork *tempEntry in docs) {
            //if (![self.appDelegate.configuration usePAIAWrapper]) {
               NSDictionary *tempEntryDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempEntry.item, @"item", tempEntry.edition, @"edition", tempEntry.bar, @"barcode", nil];
               NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempEntryDict options:NSJSONWritingPrettyPrinted error:nil];
               NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
               [jsonString appendString:tempString];
            //}
            if (![tempEntry isEqual:[docs lastObject]] && docs.count != 1)
            {
               [jsonString appendString:@","];
            }
            /*if ([self.appDelegate.configuration usePAIAWrapper]) {
               NSDictionary *tempEntryDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempEntry.item, @"item", tempEntry.edition, @"edition", tempEntry.bar, @"barcode", nil];
               NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempEntryDict options:NSJSONWritingPrettyPrinted error:nil];
               NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
               [jsonString appendString:tempString];
            }*/
         }
         if ([self.appDelegate.configuration usePAIAWrapper]) {
            [jsonString appendString:@"]"];
         } else {
            [jsonString appendString:@"]}"];
         }
         NSUInteger contentLength = [jsonString length];
         NSData *body = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
         NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] postRequestWithURL:url HTTPBody:body contentLength:contentLength];
         NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
         NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
         NSURLSessionDataTask *task = [session dataTaskWithRequest:theRequest];
         [task resume];
      } else {
         [self displayError];
      }
   }
}

- (void)accountCancelDocs:(NSArray *)docs WithAccount:(NSString *)account WithToken:(NSString *)token WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"accountCancelDocs"];
   if ([self checkNetworkReachability]) {
      if ([self checkScope:@"write_items"]) {
         NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@/core/%@/cancel?access_token=%@", [self.appDelegate.configuration getPAIAURLForCatalog:self.appDelegate.options.selectedCatalogue], [self urlencodeString:account], token]];
         NSMutableString*jsonString = [[NSMutableString alloc] init];
         if ([self.appDelegate.configuration usePAIAWrapper]) {
            [jsonString appendString:@"["];
         } else {
            [jsonString appendString:@"{\"doc\":["];
         }
         for (BAEntryWork *tempEntry in docs) {
            //if (![self.appDelegate.configuration usePAIAWrapper]) {
               NSDictionary *tempEntryDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempEntry.item, @"item", tempEntry.edition, @"edition", tempEntry.bar, @"barcode", nil];
               NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempEntryDict options:NSJSONWritingPrettyPrinted error:nil];
               NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
               [jsonString appendString:tempString];
            //}
            if (![tempEntry isEqual:[docs lastObject]] && docs.count != 1)
            {
               [jsonString appendString:@","];
            }
            /*if ([self.appDelegate.configuration usePAIAWrapper]) {
               NSDictionary *tempEntryDict = [[NSDictionary alloc] initWithObjectsAndKeys: tempEntry.item, @"item", tempEntry.edition, @"edition", tempEntry.bar, @"barcode", nil];
               NSData *tempJsonData = [NSJSONSerialization dataWithJSONObject:tempEntryDict options:NSJSONWritingPrettyPrinted error:nil];
               NSString *tempString = [[NSString alloc] initWithData:tempJsonData encoding:NSStringEncodingConversionAllowLossy];
               [jsonString appendString:tempString];
            }*/
         }
         if ([self.appDelegate.configuration usePAIAWrapper]) {
            [jsonString appendString:@"]"];
         } else {
            [jsonString appendString:@"]}"];
         }
         NSUInteger contentLength = [jsonString length];
         NSData *body = [jsonString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
         NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] postRequestWithURL:url HTTPBody:body contentLength:contentLength];
         
         NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
         NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
         NSURLSessionDataTask *task = [session dataTaskWithRequest:theRequest];
         [task resume];
      } else {
         [self displayError];
      }
   }
}

- (void)getInfoFeedWithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getInfoFeedWithDelegate"];
   //if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@", self.appDelegate.configuration.currentBibFeedURL]];
      [self resumeTaskWithUrl:url];
   //}
}

- (void)getLocationInfoForUri:(NSString *)uri WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getLocationInfoForUri"];
   if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?format=json", uri]];
      [self resumeTaskWithUrl:url];
   }
}

- (void)getLocationsForLibraryByUri:(NSString *)uri WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"getLocationsForLibraryByUri"];
   if ([self checkNetworkReachability]) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?format=json", uri]];
      [self resumeTaskWithUrl:url];
   }
}

- (void)loadLocationForUri:(NSString *)uri WithDelegate:(id)delegate
{
   [self setConnectorDelegate:delegate];
   [self setCommand:@"loadLocationForUri"];
   if ([self checkNetworkReachability]) {
      [self setBaseURL:uri];
      BALocation *resultLocation = [self loadLocationFromCacheForUri:uri];
      if (resultLocation == nil) {
         NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?format=json", uri]];
         [self resumeTaskWithUrl:url];
      } else {
         [delegate command:@"loadLocationForUri" didFinishLoadingWithResult:resultLocation];
      }
   }
}

- (BALocation *)loadLocationForUri:(NSString *)uri
{
   BALocation *resultLocation = [self loadLocationFromCacheForUri:uri];
   if (resultLocation == nil) {
      NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?format=json", uri]];
      NSData *locationData = [NSData dataWithContentsOfURL:url];
      resultLocation = [self parseLocation:locationData ForUri:uri];
   }
   return resultLocation;
}

- (BALocation *)loadLocationFromCacheForUri:(NSString *)uri {
   BALocation *resultLocation;
   NSEntityDescription *entityDescriptionLocations = [NSEntityDescription entityForName:@"BALocation" inManagedObjectContext:[self.appDelegate managedObjectContext]];
   NSFetchRequest *requestLocation = [[NSFetchRequest alloc] init];
   [requestLocation setEntity:entityDescriptionLocations];
   NSError *error = nil;
   if (self.appDelegate.locations == nil) {
      [self.appDelegate setLocations:[[self.appDelegate.managedObjectContext executeFetchRequest:requestLocation error:&error] mutableCopy]];
   }
   for (BALocation *tempLocation in self.appDelegate.locations) {
      if ([uri isEqualToString:tempLocation.uri]) {
         NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:tempLocation.timestamp];
         if (secondsBetween < 604800) {
            resultLocation = tempLocation;
         } else {
            [self.appDelegate.managedObjectContext deleteObject:tempLocation];
            NSError *error = nil;
            if (![[appDelegate managedObjectContext] save:&error]) {
               // Handle the error.
            }
         }
      }
   }
   return resultLocation;
}

- (BALocation *)parseLocation:(NSData *)locationData ForUri:(NSString *)uri {
   BALocation *resultLocation;
   if (locationData != nil) {
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
      NSDictionary* json = [NSJSONSerialization JSONObjectWithData:(NSData *)locationData options:kNilOptions error:nil];
      
      for (NSString *key in [json objectForKey:uri]) {
         if ([key isEqualToString:@"http://xmlns.com/foaf/0.1/name"]) {
            [newLocation setName:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"]];
            foundName = YES;
         }
         if ([key isEqualToString:@"http://dbpedia.org/property/shortName"]) {
            [newLocation setShortname:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"]];
            foundShortname = YES;
         }
         if ([key isEqualToString:@"http://purl.org/ontology/gbv/address"]) {
            [newLocation setAddress:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"]];
            foundAddress = YES;
         }
         if ([key isEqualToString:@"http://purl.org/ontology/gbv/openinghours"]) {
            [newLocation setOpeninghours:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"]];
            foundOpeningHours = YES;
         }
         /* if ([key isEqualToString:@"http://www.w3.org/2006/vcard/ns#email"]) {
            [newLocation setEmail:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"]];
            foundEmail = YES;
         } */
         if ([key isEqualToString:@"http://xmlns.com/foaf/0.1/mbox"]) {
            NSString *tempEmail = [[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"];
            [newLocation setEmail:[tempEmail stringByReplacingOccurrencesOfString:@"mailto:" withString:@""]];
            foundEmail = YES;
         }
         if ([key isEqualToString:@"http://www.w3.org/2006/vcard/ns#url"]) {
            [newLocation setUrl:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"]];
            foundUrl = YES;
         }
         if ([key isEqualToString:@"http://xmlns.com/foaf/0.1/phone"]) {
            [newLocation setPhone:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"]];
            foundPhone = YES;
         }
         if ([key isEqualToString:@"http://www.w3.org/2003/01/geo/wgs84_pos#location"]) {
            NSString *tempKey = [[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)] objectForKey:@"value"];
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
            [newLocation setDesc:[[[[json objectForKey:uri] objectForKey:key] objectAtIndex:([[[json objectForKey:uri] objectForKey:key] count] - 1)]objectForKey:@"value"]];
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
          if ([[json allKeys] containsObject:@"_:b2"]) {
              NSString *street = @"";
              NSString *postal = @"";
              NSString *locality = @"";
              
              for (NSString *key in [json objectForKey:@"_:b2"]) {
                  if ([key isEqualToString:@"http://www.w3.org/2006/vcard/ns#street-address"]) {
                      street = [[[[json objectForKey:@"_:b2"] objectForKey:key] objectAtIndex:([[[json objectForKey:@"_:b2"] objectForKey:key] count] - 1)]objectForKey:@"value"];
                  }
              }
              
              for (NSString *key in [json objectForKey:@"_:b2"]) {
                  if ([key isEqualToString:@"http://www.w3.org/2006/vcard/ns#postal-code"]) {
                      postal = [[[[json objectForKey:@"_:b2"] objectForKey:key] objectAtIndex:([[[json objectForKey:@"_:b2"] objectForKey:key] count] - 1)]objectForKey:@"value"];
                  }
              }
              
              for (NSString *key in [json objectForKey:@"_:b2"]) {
                  if ([key isEqualToString:@"http://www.w3.org/2006/vcard/ns#locality"]) {
                      locality = [[[[json objectForKey:@"_:b2"] objectForKey:key] objectAtIndex:([[[json objectForKey:@"_:b2"] objectForKey:key] count] - 1)]objectForKey:@"value"];
                  }
              }
              
              [newLocation setAddress:[[NSString alloc] initWithFormat:@"%@\n%@ %@", street, postal, locality]];
          } else {
              [newLocation setAddress:@""];
          }
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
   return resultLocation;
}

- (NSString*)encodeToPercentEscapeString:(NSString *)string
{
   NSString *returnString = CFBridgingRelease((__bridge CFTypeRef _Nullable)([string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]));
   return returnString;
}

- (NSString*)decodeFromPercentEscapeString:(NSString *)string
{
   NSString *returnString = CFBridgingRelease((__bridge CFTypeRef _Nullable)([string stringByRemovingPercentEncoding]));
   return returnString;
}

- (void)command:(NSString *)command didFinishLoadingWithResult:(NSObject *)result
{
    //used for searchCount.
}

- (BOOL)checkScope:(NSString *)scope {
   BOOL isAllowed = NO;
   for (NSString *tempScope in self.appDelegate.currentScope) {
      if ([tempScope isEqualToString:scope]) {
         isAllowed= YES;
      }
   }
   return isAllowed;
}

- (void)displayError {
     [self.connectorDelegate commandIsNotInScope:self.command];
     UIAlertController * alertError = [UIAlertController
                      alertControllerWithTitle:nil
                                       message:ERROR_MESSAGE_SCOPE
                                preferredStyle:UIAlertControllerStyleAlert];

     UIAlertAction* okAction = [UIAlertAction
                              actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * action) {
                                      }];

     [alertError addAction:okAction];

     id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
     if([rootViewController isKindOfClass:[UINavigationController class]])
     {
         rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
     }
     if([rootViewController isKindOfClass:[UITabBarController class]])
     {
         rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
     }

     [rootViewController presentViewController:alertError animated:YES completion:nil];
}

- (BOOL)checkNetworkReachability {
   BOOL isNetworkReachable = NO;
   Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
   NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
   if ((networkStatus != ReachableViaWiFi) && (networkStatus != ReachableViaWWAN)) {
      [self.connectorDelegate networkIsNotReachable:self.command];
      UIAlertController * alertError = [UIAlertController
                         alertControllerWithTitle:nil
                                          message:ERROR_MESSAGE_NETWORK_REACHABILITY
                                   preferredStyle:UIAlertControllerStyleAlert];

      UIAlertAction* okAction = [UIAlertAction
                                 actionWithTitle:@"Ok"
                                           style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                         }];

      [alertError addAction:okAction];

      id rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
      if([rootViewController isKindOfClass:[UINavigationController class]])
      {
          rootViewController = ((UINavigationController *)rootViewController).viewControllers.firstObject;
      }
      if([rootViewController isKindOfClass:[UITabBarController class]])
      {
          rootViewController = ((UITabBarController *)rootViewController).selectedViewController;
      }

      [rootViewController presentViewController:alertError animated:YES completion:nil];
   } else {
      isNetworkReachable = YES;
   }
   return isNetworkReachable;
}

- (NSString *)loadISBDWithPPN:(NSString *)ppn
{
   NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://unapi.k10plus.de/?id=gvk:ppn:%@&format=isbd", ppn]];
   NSData *isbdData = [NSData dataWithContentsOfURL:url];
   return [[NSString alloc] initWithData:isbdData encoding:NSUTF8StringEncoding];
}

-(void)pushServiceRegisterWithPatron:(NSString *)patron deviceId:(NSString *)deviceId delegate:(id)delegate {
    [self setConnectorDelegate:delegate];
    [self setCommand:@"pushServiceRegister"];
    
    if ([self checkNetworkReachability]) {
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/api/bibapp/register?apikey=%@", self.appDelegate.configuration.pushServiceUrl, self.appDelegate.configuration.pushServiceApiKey]];
        
        NSString *post = [NSString stringWithFormat:@"patron=%@&device_id=%@", patron, deviceId];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];

        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
        [theRequest setHTTPBody:postData];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:theRequest];
        [task resume];
    }
}

-(void)pushServiceUpdateWithPatron:(NSString *)patron deviceId:(NSString *)deviceId delegate:(id)delegate {
    [self setConnectorDelegate:delegate];
    [self setCommand:@"pushServiceUpdate"];
    
    if ([self checkNetworkReachability]) {
        
    }
}

-(void)pushServiceUpdateWithDeviceId:(NSString *)deviceId delegate:(id)delegate {
    [self setConnectorDelegate:delegate];
    [self setCommand:@"pushServiceUpdateDeviceId"];
    
    if ([self checkNetworkReachability]) {
        
    }
}

-(void)pushServiceRemoveWithPushServerId:(NSString *)pushServerId delegate:(id)delegate {
    [self setConnectorDelegate:delegate];
    [self setCommand:@"pushServiceRemove"];
    
    if ([self checkNetworkReachability]) {
        NSURL *url = [NSURL URLWithString:[[NSString alloc] initWithFormat:@"%@/api/bibapp/remove/%@?apikey=%@", self.appDelegate.configuration.pushServiceUrl, pushServerId, self.appDelegate.configuration.pushServiceApiKey]];
        
        NSMutableURLRequest *theRequest = [[NSMutableURLRequest alloc] initWithURL:url];
        [theRequest setHTTPMethod:@"DELETE"];

        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:theRequest];
        [task resume];
    }
}

- (void)getDetailsForLocalFam:(NSString *)ppn WithStart:(long)start WithDelegate:(id)delegate
{
    [self setConnectorDelegate:delegate];
    [self setCommand:@"getDetailsLocalFam"];
    if ([self checkNetworkReachability]) {
        NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%@?FRST=%ld&PPN=%@&XML=YES", [self.appDelegate.configuration getDetailFamURLForCatalog:self.appDelegate.options.selectedCatalogue], start, ppn]];
        
        NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
        
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:theRequest];
        [task resume];
    }
}

-(NSString *) urlencodeString:(NSString *)string {
    NSString *result = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    for (NSString *character in self.urlencodeCharacters) {
        result = [result stringByReplacingOccurrencesOfString:character withString:[self.urlencodeCharacters objectForKey:character]];
    }
    return result;
}

-(void) resumeTaskWithUrl:(NSURL *)url {
    NSURLRequest *theRequest = [[BAURLRequestService sharedInstance] getRequestWithUrl:url];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:theRequest];
    [task resume];
}

@end
