//
//  TMWHTTPClient.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWHTTPClient.h"
@import Foundation;
#import "NSDictionary+JSONString.h"
#import "TMWCustomLogs.h"

typedef NS_ENUM(NSUInteger, TMWHTTPClientEnvironment) {
    TMWHTTPClientEnvironmentDevelopment,
    TMWHTTPClientEnvironmentProduction,
};

NSString * const TMWHTTPClientUsername = @"ilgeonamessample";

static NSString * const TMWHTTPClientBaseURLDevelopment = @"http://api.geonames.org/";
static NSString * const TMWHTTPClientBaseURLProduction = @"http://api.geonames.org/";

static NSString * const TMWHTTPClientServiceParamErrorMessage = @"error";

@interface TMWHTTPClient ()
@property (assign, nonatomic) TMWHTTPClientEnvironment currentEnvironment;
@end

@implementation TMWHTTPClient

+ (instancetype)sharedClient {
    static id _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ///////
        //
        // SET HERE THE ENVIRONMENT TO USE
        //
        _sharedClient = [[self alloc] initWithEnvironment:TMWHTTPClientEnvironmentDevelopment];
        //
        ///////
    });
    
    return _sharedClient;
}

- (instancetype)initWithEnvironment:(TMWHTTPClientEnvironment)environment {
    _currentEnvironment = environment;
    
    NSString *baseUrl;
    switch (environment) {
        case TMWHTTPClientEnvironmentDevelopment:
        {
            baseUrl = TMWHTTPClientBaseURLDevelopment;
            break;
        }
        case TMWHTTPClientEnvironmentProduction:
        {
            baseUrl = TMWHTTPClientBaseURLProduction;
            break;
        }
    }
    
    return [self initWithBaseURL:[NSURL URLWithString:baseUrl]];
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [self.reachabilityManager startMonitoring];
    [self.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
            {
                TMWLog(@"Reachability is DOWN");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                TMWLog(@"Reachability is OK via WiFi");
                break;
            }
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                TMWLog(@"Reachability is OK via WWAN");
                break;
            }
                
            case AFNetworkReachabilityStatusUnknown:
            {
                TMWLog(@"Reachability is UNKNOWN");
                break;
            }
        }
    }];
    
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
{
    // Log request POST params
    if ([request.HTTPMethod isEqualToString:@"POST"] ||
        [request.HTTPMethod isEqualToString:@"PUT"]) {
        NSError *error;
        id json = [NSJSONSerialization JSONObjectWithData:request.HTTPBody
                                                  options:kNilOptions
                                                           error:&error];
        if (!error && [json isKindOfClass:[NSDictionary class]]) {
            TMWLog(@"REQUEST: %@", [json stringWithJSONPrettyPrinted:YES]);
        }
    }
    
    // Log HEADERS
    TMWLog(@"HEADERS: %@", request.allHTTPHeaderFields);
    
    return [super dataTaskWithRequest:request
                    completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                        NSError *customError = [self parseURLResponse:response responseObject:responseObject error:error];
                        if (completionHandler) {
                            completionHandler(response, responseObject, customError);
                        }
                    }];
}

- (NSURLSessionUploadTask *)uploadTaskWithStreamedRequest:(NSURLRequest *)request
                                                 progress:(NSProgress *__autoreleasing *)progress
                                        completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler
{
    return [super uploadTaskWithStreamedRequest:request
                                       progress:progress
                              completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                                  NSError *customError = [self parseURLResponse:response responseObject:responseObject error:error];
                                  if (completionHandler)
                                      completionHandler(response, responseObject, customError);
                              }];
}

#pragma mark - Private methods
- (NSError *)parseURLResponse:(NSURLResponse *)response responseObject:(id)responseObject error:(NSError *)error {
    NSError *customError;
    
    // With response object
    if (responseObject)
    {
        TMWLog(@"RESPONSE: %@", [responseObject stringWithJSONPrettyPrinted:YES]);
        NSString *errorMessage = [responseObject valueForKeyPath:TMWHTTPClientServiceParamErrorMessage];
        if (errorMessage) {
            NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
            NSInteger statusCode = [HTTPResponse statusCode];
            
            customError = [NSError errorWithDomain:NSStringFromClass([self class])
                                              code:statusCode
                                          userInfo:@{NSLocalizedDescriptionKey: errorMessage}];
        }
    }
    
    // No response object
    else if (error)
    {
        customError = [NSError errorWithDomain:NSStringFromClass([self class])
                                          code:0
                                      userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"alert_message_generic_error", nil)}];
    }
    
    return customError;
}
@end
