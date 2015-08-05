//
//  TMWGeoPoint.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMWCardinalPoints.h"

@interface TMWGeoPoint : NSObject <NSCoding, NSCopying>
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *countryName;
@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) TMWCardinalPoints *cardinalPoints;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSDictionary *)toDictionary;
@end
