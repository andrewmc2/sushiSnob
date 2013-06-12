//
//  MSTranslateVendor.m
//  MSTranslateVendor
//
//  Created by Minseok Shim on 13. 1. 14..
//  Copyright (c) 2013 Minseok Shim. All rights reserved.
//

#import "MSTranslateAccessTokenRequester.h"
#import "NSMutableURLRequest+WebServiceExtend.h"

@interface MSTranslateAccessTokenRequester()
{
    NSMutableURLRequest *_request;
}

@property (nonatomic, readwrite) NSString *accessToken;
@end

@implementation MSTranslateAccessTokenRequester

const NSString *scope = @"http://api.microsofttranslator.com";
const NSString *grant_type = @"client_credentials";

static MSTranslateAccessTokenRequester *sharedRequester = nil;

+ (MSTranslateAccessTokenRequester *)sharedRequester
{
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ sharedRequester = [[self alloc] init]; });
    }
    return sharedRequester;
}

- (void)requestAsynchronousAccessToken:(NSString *)client_id clientSecret:(NSString *)client_secret
{
    _request = [[NSMutableURLRequest alloc] init];
    
    NSURL *OAuthURL = [NSURL URLWithString:@"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"];
    NSDictionary *dict = @{@"scope" : scope, @"grant_type" : grant_type, @"client_id" : client_id, @"client_secret" : client_secret};
    
    [_request setURL:[OAuthURL standardizedURL]];
	[_request setHTTPMethod:@"POST"];
    [_request setFormPostParameters:dict];
    [NSURLConnection sendAsynchronousRequest:_request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length])
         {
             id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
             NSArray *keys = [jsonObjects allKeys];
             
             for (NSString *key in keys)
             {
                 if([key isEqualToString:@"access_token"])
                 {
                     self.accessToken = [jsonObjects objectForKey:key];
                 }
             }
         }
         
     }];
}

- (void)requestSynchronousAccessToken:(NSString *)client_id clientSecret:(NSString *)client_secret
{
    _request = [[NSMutableURLRequest alloc] init];
    
    NSURL *OAuthURL = [NSURL URLWithString:@"https://datamarket.accesscontrol.windows.net/v2/OAuth2-13"];
    NSDictionary *dict = @{@"scope" : scope, @"grant_type" : grant_type, @"client_id" : client_id, @"client_secret" : client_secret};
    
    [_request setURL:[OAuthURL standardizedURL]];
	[_request setHTTPMethod:@"POST"];
    [_request setFormPostParameters:dict];
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:_request returningResponse:&response error:nil];
    if([data length])
    {
        id jsonObjects = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *keys = [jsonObjects allKeys];
        
        for (NSString *key in keys)
        {
            if([key isEqualToString:@"access_token"])
            {
                self.accessToken = [jsonObjects objectForKey:key];
            }
        }
    }
}
@end
