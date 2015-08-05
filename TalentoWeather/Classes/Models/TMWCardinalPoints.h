//
//  TMWCardinalPoints.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMWCardinalPoints : NSObject <NSCoding, NSCopying>
@property (strong, nonatomic) NSNumber *south;
@property (strong, nonatomic) NSNumber *east;
@property (strong, nonatomic) NSNumber *north;
@property (strong, nonatomic) NSNumber *west;

- (instancetype)initWithAttributes:(NSDictionary *)attributes;
- (NSDictionary *)toDictionary;
@end
