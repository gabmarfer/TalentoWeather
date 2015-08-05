//
//  TMWMeasure.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWMeasure.h"
#import "GMParser.h"

static NSString * const TMWMeasureTemperature = @"temperature";
static NSString * const TMWMeasureHumidity = @"humidity";
static NSString * const TMWMeasureClouds = @"clouds";
static NSString * const TMWMeasureWindSpeed = @"windSpeed";
static NSString * const TMWMeasureLatitude = @"lat";
static NSString * const TMWMeasureLongitude = @"lng";
static NSString * const TMWMeasureDate = @"datetime";
static NSString * const TMWMeasureStationName = @"stationName";

@implementation TMWMeasure

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _temperature = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWMeasureTemperature]];
        _humidity = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWMeasureHumidity]];
        _clouds = [GMParser parseStringFromString:[attributes valueForKeyPath:TMWMeasureClouds]];
        _windSpeed = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWMeasureWindSpeed]];
        _latitude = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWMeasureLatitude]];
        _longitude = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWMeasureLongitude]];
        _predictionDate = [GMParser parseDateFromString:[attributes valueForKeyPath:TMWMeasureDate]];
        _stationName = [GMParser parseStringFromString:[attributes valueForKeyPath:TMWMeasureStationName]];
    }
    return self;
}

- (instancetype)init {
    return [self initWithAttributes:@{}];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _temperature = [aDecoder decodeObjectForKey:TMWMeasureTemperature];
        _humidity = [aDecoder decodeObjectForKey:TMWMeasureHumidity];
        _clouds = [aDecoder decodeObjectForKey:TMWMeasureClouds];
        _windSpeed = [aDecoder decodeObjectForKey:TMWMeasureWindSpeed];
        _latitude = [aDecoder decodeObjectForKey:TMWMeasureLatitude];
        _longitude = [aDecoder decodeObjectForKey:TMWMeasureLongitude];
        _predictionDate = [aDecoder decodeObjectForKey:TMWMeasureDate];
        _stationName = [aDecoder decodeObjectForKey:TMWMeasureStationName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.temperature forKey:TMWMeasureTemperature];
    [aCoder encodeObject:self.humidity forKey:TMWMeasureHumidity];
    [aCoder encodeObject:self.clouds forKey:TMWMeasureClouds];
    [aCoder encodeObject:self.windSpeed forKey:TMWMeasureWindSpeed];
    [aCoder encodeObject:self.latitude forKey:TMWMeasureLatitude];
    [aCoder encodeObject:self.longitude forKey:TMWMeasureLongitude];
    [aCoder encodeObject:self.predictionDate forKey:TMWMeasureDate];
    [aCoder encodeObject:self.stationName forKey:TMWMeasureStationName];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.toDictionary];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setValue:self.temperature forKey:TMWMeasureTemperature];
    [mutableDict setValue:self.humidity forKey:TMWMeasureHumidity];
    [mutableDict setValue:self.clouds forKey:TMWMeasureClouds];
    [mutableDict setValue:self.windSpeed forKey:TMWMeasureWindSpeed];
    [mutableDict setValue:self.latitude forKey:TMWMeasureLatitude];
    [mutableDict setValue:self.longitude forKey:TMWMeasureLongitude];
    [mutableDict setValue:self.predictionDate forKey:TMWMeasureDate];
    [mutableDict setValue:self.stationName forKey:TMWMeasureStationName];
    return mutableDict;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[TMWMeasure class]]) {
        return NO;
    }
    
    TMWMeasure *other = (TMWMeasure *)object;
    BOOL haveSameStationName = ([self.stationName isEqualToString:other.stationName]);
    BOOL haveSameLatitude = ([self.latitude isEqualToNumber:other.latitude]);
    BOOL haveSameLongitude = ([self.longitude isEqualToNumber:other.longitude]);
    BOOL haveSameDate = ([self.predictionDate isEqualToDate:other.predictionDate]);
    
    return (haveSameStationName && haveSameLatitude && haveSameLongitude && haveSameDate);
}

- (NSUInteger)hash {
    return self.stationName.hash ^
    self.latitude.hash ^
    self.longitude.hash ^
    self.predictionDate.hash;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    TMWMeasure *obj = [[self.class allocWithZone:zone] init];
    obj->_temperature = self.temperature;
    obj->_humidity = self.humidity;
    obj->_clouds = self.clouds;
    obj->_windSpeed = self.windSpeed;
    obj->_latitude = self.latitude;
    obj->_longitude = self.longitude;
    obj->_predictionDate = self.predictionDate;
    
    return obj;
}

@end
