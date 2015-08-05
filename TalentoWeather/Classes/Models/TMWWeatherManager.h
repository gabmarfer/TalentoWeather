//
//  TMWWeatherManager.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMWGeoPoint.h"
#import "TMWPrediction.h"

@interface TMWWeatherManager : NSObject

/// A list of historic searches
@property (strong, nonatomic, readonly) NSArray *searches;

+ (instancetype)sharedManager;

#pragma mark - Manage historic searches
- (void)addHistoricSearch:(TMWGeoPoint *)geoPoint;

/*
 * Get a historic GeoPoint based on its coordinates
 */
- (TMWGeoPoint *)historicGeoPointWithLatitude:(NSNumber *)latitude
                                    longitude:(NSNumber *)longitude;

#pragma mark - Web service calls
/**
 * Fetch a Geo Point based on a given query string
 *
 * @param query The text to search within a geo point name
 * @param block A block with a found geo point and an error or nil
 * @return
 */
- (void)requestGetGeoPointWithQuery:(NSString *)query
                              block:(void (^)(TMWGeoPoint *geoPoint, NSError *error))block;

/**
 * Fetch a prediction for a given cardinal points
 *
 * @param cardinalPoints The points to retrieve its prediction
 * @param block A block with the found prediction and an error or nil
 * @return
 */
- (void)requestGetPredictionForCardinalPoints:(TMWCardinalPoints *)cardinalPoints
                                        block:(void (^)(TMWPrediction *prediction, NSError *error))block;
@end
