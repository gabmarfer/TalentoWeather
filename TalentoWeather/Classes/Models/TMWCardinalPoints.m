//
//  TMWCardinalPoints.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWCardinalPoints.h"
#import "GMParser.h"

static NSString * const TMWCardinalPointsSouth = @"south";
static NSString * const TMWCardinalPointsEast = @"east";
static NSString * const TMWCardinalPointsNorth = @"north";
static NSString * const TMWCardinalPointsWest = @"west";

@implementation TMWCardinalPoints

- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (self) {
        _south = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWCardinalPointsSouth]];
        _east = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWCardinalPointsEast]];
        _north = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWCardinalPointsNorth]];
        _west = [GMParser parseIntegerNumberFromString:[attributes valueForKeyPath:TMWCardinalPointsWest]];
    }
    return self;
}

- (instancetype)init {
    return [self initWithAttributes:@{}];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _south = [aDecoder decodeObjectForKey:TMWCardinalPointsSouth];
        _east = [aDecoder decodeObjectForKey:TMWCardinalPointsEast];
        _north = [aDecoder decodeObjectForKey:TMWCardinalPointsNorth];
        _west = [aDecoder decodeObjectForKey:TMWCardinalPointsWest];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.south forKey:TMWCardinalPointsSouth];
    [aCoder encodeObject:self.east forKey:TMWCardinalPointsEast];
    [aCoder encodeObject:self.north forKey:TMWCardinalPointsNorth];
    [aCoder encodeObject:self.west forKey:TMWCardinalPointsWest];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", self.toDictionary];
}

- (NSDictionary *)toDictionary {
    NSMutableDictionary *mutableDict = [NSMutableDictionary new];
    [mutableDict setValue:self.south forKey:TMWCardinalPointsSouth];
    [mutableDict setValue:self.east forKey:TMWCardinalPointsEast];
    [mutableDict setValue:self.north forKey:TMWCardinalPointsNorth];
    [mutableDict setValue:self.west forKey:TMWCardinalPointsWest];
    return mutableDict;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[TMWCardinalPoints class]]) {
        return NO;
    }
    
    TMWCardinalPoints *other = (TMWCardinalPoints *)object;
    BOOL haveEqualSouth = ([self.south isEqualToNumber:other.south]);
    BOOL haveEqualEast = ([self.east isEqualToNumber:other.east]);
    BOOL haveEqualNorth = ([self.north isEqualToNumber:other.north]);
    BOOL haveEqualWest = ([self.west isEqualToNumber:other.west]);
    
    return (haveEqualSouth && haveEqualEast && haveEqualNorth && haveEqualWest);
}

- (NSUInteger)hash {
    return self.south.hash ^
    self.east.hash ^
    self.north.hash ^
    self.west.hash;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    TMWCardinalPoints *obj = [[self.class allocWithZone:zone] init];
    obj->_south = self.south;
    obj->_east = self.east;
    obj->_north = self.north;
    obj->_west = self.west;
    
    return obj;
}

@end
