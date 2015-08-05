//
//  NSDictionary+JSONString.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (JSONString)
/**
 * Returns a NSString containing a JSON converted from a Dictionary
 *
 * @param prettyPrinted a BOOL that indicates if the JSON should be printed in a readable way
 * @return NSString the string containing the JSON or an error description
 */
- (NSString *)stringWithJSONPrettyPrinted:(BOOL)prettyPrinted;
@end
