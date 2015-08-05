//
//  TMWWeatherManager.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWWeatherManager.h"
@import CoreLocation;
#import "TMWHTTPClient.h"
#import "GMParser.h"
#import "TMWHelpers.h"

static NSString * const TMWWeatherManagerHistoricSearchesCachePath = @"historic.archive";

@interface TMWWeatherManager ()
@property (strong, nonatomic) NSMutableArray *privateSearches;

- (NSString *)p_historicCachePath;
@end

@implementation TMWWeatherManager

+ (instancetype)sharedManager {
    static id _sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] initPrivate];
    });
    
    return _sharedManager;
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        [self p_loadHistoricSearches];
    }
    return self;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use +[TMWWeatherManager sharedManager]"
                                 userInfo:nil];
    return nil;
}

#pragma mark - Manage historic searches
#pragma mark --- Private
- (void)p_loadHistoricSearches {
    if (!_privateSearches) {
        _privateSearches = [NSKeyedUnarchiver unarchiveObjectWithFile:self.p_historicCachePath];
    }
    
    if (!_privateSearches) {
        _privateSearches = [NSMutableArray new];
    }
}

- (NSString *)p_historicCachePath {
    return pathInDocumentDirectory(TMWWeatherManagerHistoricSearchesCachePath);
}

- (BOOL)p_saveHistoricSearches {
    return [NSKeyedArchiver archiveRootObject:self.privateSearches toFile:self.p_historicCachePath];
}

#pragma mark --- Public
- (NSArray *)searches {
    return [self.privateSearches copy];
}

- (void)addHistoricSearch:(TMWGeoPoint *)geoPoint {
    // Take care of nil values
    if (!geoPoint) {
        return;
    }
    
    // Avoid duplicates
    if ([self.privateSearches containsObject:geoPoint]) {
        return;
    }
    
    // Insert at the beginning to keep sort by recent date
    [self.privateSearches insertObject:geoPoint atIndex:0];
    
    // Save to disk
    [self p_saveHistoricSearches];
}

- (TMWGeoPoint *)historicGeoPointWithLatitude:(NSNumber *)latitude
                                    longitude:(NSNumber *)longitude {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.latitude == %@ AND SELF.longitude == longitude", latitude, longitude];
    NSArray *filteredHistoric = [self.searches filteredArrayUsingPredicate:predicate];
    return filteredHistoric.firstObject;
}

#pragma mark - Web service calls
- (void)requestGetGeoPointWithQuery:(NSString *)query
                              block:(void (^)(TMWGeoPoint *, NSError *))block {
    // Avoid calling to the endpoint if query is empty
    if (!query) {
        if (block) {
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:0
                                             userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"alert_message_invalid_query", nil)}];
            block(nil, error);
        }
    }
    else {
    
        NSDictionary *params = @{TMWServiceParamQuery: query,
                                 TMWServiceParamMaxRows: @(20),
                                 TMWServiceParamStartRow: @(0),
                                 TMWServiceParamLang: @"en",
                                 TMWServiceParamIsNameRequired: @(YES),
                                 TMWServiceParamStyle: @"FULL",
                                 TMWServiceParamUsername: TMWHTTPClientUsername,
                                 };
        
        [[TMWHTTPClient sharedClient] GET:TMWServicePathSearch
                               parameters:params
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      NSArray *responseGeoPoints = [GMParser parseArrayFromComplexObject:[responseObject valueForKeyPath:TMWServiceParamGeoNames]];
                                      if (responseGeoPoints.count > 0) {
                                          // Instead of parsing all the returned elements, we are gonna take the first one
                                          // Assuming that the endpoint returns the elements order by accuracy of match
                                          TMWGeoPoint *parsedGeoPoint = [[TMWGeoPoint alloc] initWithAttributes:(NSDictionary *)responseGeoPoints.firstObject];
                                          if (block) {
                                              block(parsedGeoPoint, nil);
                                          }
                                      } else {
                                          if (block) {
                                              NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                                                   code:0
                                                                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"alert_message_location_not_found", nil)}];
                                              block(nil, error);
                                          }
                                      }
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      if (block) {
                                          block(nil, error);
                                      }
                                  }];
    }
    
}

- (void)requestGetPredictionForCardinalPoints:(TMWCardinalPoints *)cardinalPoints
                                        block:(void (^)(TMWPrediction *, NSError *))block {
    // Avoid calling to the endpoint if cardinalPoints is empty
    if (!cardinalPoints) {
        if (block) {
            NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                 code:0
                                             userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"alert_message_no_weather_found", nil)}];
            block(nil, error);
        }
    }
    else {
        NSMutableDictionary *params = [@{TMWServiceParamUsername: TMWHTTPClientUsername,} mutableCopy];
        [params addEntriesFromDictionary:cardinalPoints.toDictionary];
        
        [[TMWHTTPClient sharedClient] GET:TMWServicePathWeather
                               parameters:params
                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                      TMWPrediction *parsedPrediction = [[TMWPrediction alloc] initWithAttributes:(NSDictionary *)responseObject
                                                                                                   cardinalPoints:cardinalPoints];
                                      if (parsedPrediction.predictions.count > 0)
                                      {
                                          if (block) {
                                              block(parsedPrediction, nil);
                                          }
                                      }
                                      else
                                      {
                                          if (block) {
                                              NSError *error = [NSError errorWithDomain:NSStringFromClass([self class])
                                                                                   code:0
                                                                               userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"alert_message_no_weather_found", nil)}];
                                              block(nil, error);
                                          }

                                      }
                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                      if (block) {
                                          block(nil, error);
                                      }
                                  }];
    }
}
@end
