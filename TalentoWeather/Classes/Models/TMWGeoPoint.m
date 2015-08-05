//
//  TMWGeoPoint.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWGeoPoint.h"
#import "GMParser.h"

static NSString * const TMWGeoPointName = @"name";
static NSString * const TMWGeoPointLatitude = @"lat";
static NSString * const TMWGeoPointLongitude = @"lng";
static NSString * const TMWGeoPointCardinalPoints = @"bbox";
static NSString * const TMWGeoPointCountryName = @"countryName";

@implementation TMWGeoPoint

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _name = [GMParser parseStringFromString:[attributes valueForKeyPath:TMWGeoPointName]];
        _latitude = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWGeoPointLatitude]];
        _longitude = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWGeoPointLongitude]];
        _cardinalPoints = [[TMWCardinalPoints alloc] initWithAttributes:[attributes valueForKeyPath:TMWGeoPointCardinalPoints]];
        _countryName = [GMParser parseStringFromString:[attributes valueForKeyPath:TMWGeoPointCountryName]];
    }
    return self;
}

- (instancetype)init {
    return [self initWithAttributes:@{}];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:TMWGeoPointName];
        _latitude = [aDecoder decodeObjectForKey:TMWGeoPointLatitude];
        _longitude = [aDecoder decodeObjectForKey:TMWGeoPointLongitude];
        _cardinalPoints = [aDecoder decodeObjectForKey:TMWGeoPointCardinalPoints];
        _countryName = [aDecoder decodeObjectForKey:TMWGeoPointCountryName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:TMWGeoPointName];
    [aCoder encodeObject:self.latitude forKey:TMWGeoPointLatitude];
    [aCoder encodeObject:self.longitude forKey:TMWGeoPointLongitude];
    [aCoder encodeObject:self.cardinalPoints forKey:TMWGeoPointCardinalPoints];
    [aCoder encodeObject:self.countryName forKey:TMWGeoPointCountryName];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.toDictionary];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setValue:self.name forKey:TMWGeoPointName];
    [mutableDict setValue:self.latitude forKey:TMWGeoPointLatitude];
    [mutableDict setValue:self.longitude forKey:TMWGeoPointLongitude];
    [mutableDict setValue:self.cardinalPoints.toDictionary forKey:TMWGeoPointCardinalPoints];
    [mutableDict setValue:self.countryName forKey:TMWGeoPointCountryName];
    return mutableDict;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[TMWGeoPoint class]]) {
        return NO;
    }
    
    TMWGeoPoint *other = (TMWGeoPoint *)object;
    BOOL haveEqualLatitude = ([self.latitude isEqualToNumber:other.latitude]);
    BOOL haveEqualLongitude = ([self.longitude isEqualToNumber:other.longitude]);
    
    return (haveEqualLatitude && haveEqualLongitude);
}

- (NSUInteger)hash {
    return self.latitude.hash ^ self.longitude.hash;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    TMWGeoPoint *obj = [[self.class allocWithZone:zone] init];
    obj->_name = self.name;
    obj->_latitude = self.latitude;
    obj->_longitude = self.longitude;
    obj->_cardinalPoints = self.cardinalPoints;
    obj->_countryName = self.countryName;
    
    return obj;
}


@end
