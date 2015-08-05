//
//  TMWPrediction.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWPrediction.h"
#import "GMParser.h"
#import "TMWCardinalPoints.h"

static NSString * const TMWPredictionWeatherObservations = @"weatherObservations";
static NSString * const TMWPredictionRequestDate = @"requestDate";
static NSString * const TMWPredictionCardinalPoints = @"cardinalPoints";

// These images could be retrieved from a web service
static NSString * const TMWPredictionBackgroundImageFrozen = @"frozen";
static NSString * const TMWPredictionIconImageFrozen = @"ic_frozen";
static NSString * const TMWPredictionBackgroundImageCold = @"cold";
static NSString * const TMWPredictionIconImageCold = @"ic_cold";
static NSString * const TMWPredictionBackgroundImageWarm = @"warm";
static NSString * const TMWPredictionIconImageWarm = @"ic_warm";
static NSString * const TMWPredictionBackgroundImageHeat = @"heat";
static NSString * const TMWPredictionIconImageHeat = @"ic_heat";
static NSString * const TMWPredictionBackgroundImageVeryHot = @"veryhot";
static NSString * const TMWPredictionIconImageVeryHot = @"ic_veryhot";

@interface TMWPrediction ()
@property (strong, nonatomic) NSMutableArray *privatePredictions;
@end

@implementation TMWPrediction

- (instancetype)initWithAttributes:(NSDictionary *)attributes cardinalPoints:(TMWCardinalPoints *)cardinalPoints {
    self = [super init];
    if (self) {
        _requestDate = [NSDate date];
        _cardinalPoints = cardinalPoints;
        
        NSArray *responsePredictions = [GMParser parseArrayFromComplexObject:[attributes valueForKeyPath:TMWPredictionWeatherObservations]];
        _privatePredictions = [NSMutableArray new];
        [responsePredictions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            TMWMeasure *aMeasure = [[TMWMeasure alloc] initWithAttributes:(NSDictionary *)obj];
            [_privatePredictions addObject:aMeasure];
        }];
    }
    return self;
}

- (instancetype)init {
    return [self initWithAttributes:@{} cardinalPoints:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _privatePredictions = [aDecoder decodeObjectForKey:TMWPredictionWeatherObservations];
        _requestDate = [aDecoder decodeObjectForKey:TMWPredictionRequestDate];
        _cardinalPoints = [aDecoder decodeObjectForKey:TMWPredictionCardinalPoints];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.predictions forKey:TMWPredictionWeatherObservations];
    [aCoder encodeObject:self.requestDate forKey:TMWPredictionRequestDate];
    [aCoder encodeObject:self.cardinalPoints forKey:TMWPredictionCardinalPoints];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.toDictionary];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setValue:self.predictions forKey:TMWPredictionWeatherObservations];
    [mutableDict setValue:self.requestDate forKey:TMWPredictionRequestDate];
    [mutableDict setValue:self.cardinalPoints forKey:TMWPredictionCardinalPoints];
    return mutableDict;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[TMWPrediction class]]) {
        return NO;
    }
    
    TMWPrediction *other = (TMWPrediction *)object;
    BOOL haveSamePoints = ([self.cardinalPoints isEqual:other.cardinalPoints]);
    BOOL haveSameDate = ([self.requestDate isEqualToDate:other.requestDate]);
    
    return (haveSamePoints && haveSameDate);
}

- (NSUInteger)hash {
    return self.requestDate.hash;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    TMWPrediction *obj = [[self.class allocWithZone:zone] init];
    obj->_privatePredictions = [self.privatePredictions mutableCopy];
    obj->_requestDate = self.requestDate;
    obj->_cardinalPoints = self.cardinalPoints;
    
    return obj;
}

#pragma mark - Accessors
- (NSArray *)predictions {
    return [self.privatePredictions copy];
}

// Calculate the average temperature
- (NSNumber *)averageTemperature {
    __block CGFloat temp = 0;
    [self.predictions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        TMWMeasure *measure = (TMWMeasure *)obj;
        if (measure.temperature) {
            temp += measure.temperature.floatValue;
        }
    }];
    
    CGFloat average = temp/self.predictions.count;
    return @(average);
}

- (TMWMeasure *)lastMeasure {
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"predictionDate" ascending:NO];
    NSArray *sortedMeasures = [self.predictions sortedArrayUsingDescriptors:@[sort]];
    return sortedMeasures.firstObject;
}

- (UIImage *)temperatureBackgroundImage {
    TMWPredictionTempType tempType = [self p_typeOfTemperature:self.averageTemperature];
    NSString *imageName;
    switch (tempType) {
        case TMWPredictionTempTypeFrozen:
        {
            imageName = TMWPredictionBackgroundImageFrozen;
            break;
        }
        case TMWPredictionTempTypeCold:
        {
            imageName = TMWPredictionBackgroundImageCold;
            break;
        }
        case TMWPredictionTempTypeWarm:
        {
            imageName = TMWPredictionBackgroundImageWarm;
            break;
        }
        case TMWPredictionTempTypeHeat:
        {
            imageName = TMWPredictionBackgroundImageHeat;
            break;
        }
        case TMWPredictionTempTypeVeryHot:
        {
            imageName = TMWPredictionBackgroundImageVeryHot;
            break;
        }
    }
    return [UIImage imageNamed:imageName];
}

- (UIImage *)temperatureIconImage {
    TMWPredictionTempType tempType = [self p_typeOfTemperature:self.averageTemperature];
    NSString *imageName;
    switch (tempType) {
        case TMWPredictionTempTypeFrozen:
        {
            imageName = TMWPredictionIconImageFrozen;
            break;
        }
        case TMWPredictionTempTypeCold:
        {
            imageName = TMWPredictionIconImageCold;
            break;
        }
        case TMWPredictionTempTypeWarm:
        {
            imageName = TMWPredictionIconImageWarm;
            break;
        }
        case TMWPredictionTempTypeHeat:
        {
            imageName = TMWPredictionIconImageHeat;
            break;
        }
        case TMWPredictionTempTypeVeryHot:
        {
            imageName = TMWPredictionIconImageVeryHot;
            break;
        }
    }
    return [UIImage imageNamed:imageName];
}

- (UIColor *)temperatureColor {
    TMWPredictionTempType tempType = [self p_typeOfTemperature:self.averageTemperature];
    return [self colorForTemperatureType:tempType];
}

#pragma mark - Utilities
- (TMWPredictionTempType)p_typeOfTemperature:(NSNumber *)temp {
    int roundTemp = (int)roundf(temp.floatValue);
    if (roundTemp < TMWPredictionTempTypeCold) {
        return TMWPredictionTempTypeFrozen;
    } else if (roundTemp < TMWPredictionTempTypeWarm) {
        return TMWPredictionTempTypeCold;
    } else if (roundTemp < TMWPredictionTempTypeHeat) {
        return TMWPredictionTempTypeWarm;
    } else if (roundTemp < TMWPredictionTempTypeVeryHot) {
        return TMWPredictionTempTypeHeat;
    } else  {
        return TMWPredictionTempTypeVeryHot;
    }
}

- (UIColor *)colorForTemperatureType:(TMWPredictionTempType)tempType {
    switch (tempType) {
        case TMWPredictionTempTypeFrozen:
        {
            return [UIColor purpleColor];
            break;
        }
        case TMWPredictionTempTypeCold:
        {
            return [UIColor blueColor];
            break;
        }
        case TMWPredictionTempTypeWarm:
        {
            return [UIColor greenColor];
            break;
        }
        case TMWPredictionTempTypeHeat:
        {
            return [UIColor orangeColor];
            break;
        }
        case TMWPredictionTempTypeVeryHot:
        {
            return [UIColor redColor];
            break;
        }
    }
}

@end
