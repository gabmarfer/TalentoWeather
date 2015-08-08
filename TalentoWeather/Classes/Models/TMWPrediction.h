//
//  TMWPrediction.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "TMWMeasure.h"

// The limits of the temperature scale
typedef NS_ENUM(NSInteger, TMWPredictionTempType) {
    TMWPredictionTempTypeFrozen = 0,
    TMWPredictionTempTypeCold = 10,
    TMWPredictionTempTypeWarm = 20,
    TMWPredictionTempTypeHeat = 25,
    TMWPredictionTempTypeVeryHot = 30,
};

@class TMWCardinalPoints;

@interface TMWPrediction : NSObject <NSCoding, NSCopying>
@property (strong, nonatomic) NSDate *requestDate; // Store it to allow compare TMWPrediction objects
@property (strong, nonatomic) TMWCardinalPoints *cardinalPoints; // Store it to allow compare TMWPrediction objects
@property (strong, nonatomic, readonly) NSArray *predictions;

/// The average temperature of the all measures include in this prediction
@property (strong, nonatomic, readonly) NSNumber *averageTemperature;

/// A background image representing the temperature
@property (strong, nonatomic, readonly) UIImage *temperatureBackgroundImage;

/// An icon representing the temperature
@property (strong, nonatomic, readonly) UIImage *temperatureIconImage;

/// A color representing the temperature
@property (strong, nonatomic, readonly) UIColor *temperatureColor;

/// The most recent clouds report
@property (strong, nonatomic) TMWMeasure *lastMeasure;

- (instancetype)initWithAttributes:(NSDictionary *)attributes
                    cardinalPoints:(TMWCardinalPoints *)cardinalPoints;
- (NSDictionary *)toDictionary;

- (UIColor *)colorForTemperatureType:(TMWPredictionTempType)tempType;
@end
