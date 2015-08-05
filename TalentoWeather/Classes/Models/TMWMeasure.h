//
//  TMWMeasure.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMWMeasure : NSObject <NSCoding, NSCopying>
@property (strong, nonatomic) NSNumber *temperature;
@property (copy, nonatomic) NSString *clouds;
@property (strong, nonatomic) NSNumber *humidity;
@property (strong, nonatomic) NSNumber *windSpeed;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSDate *predictionDate;
@property (copy, nonatomic) NSString *stationName;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSDictionary *)toDictionary;

@end
