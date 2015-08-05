//
//  TMWHTTPClient.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "TMWServiceConstants.h"

extern NSString * const TMWHTTPClientUsername;

@interface TMWHTTPClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
@end
