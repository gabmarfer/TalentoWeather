//
//  GMParser.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "GMParser.h"

@implementation GMParser

+ (NSString *)parseStringFromString:(NSString *)aString {
    if (!aString || [aString isEqual:[NSNull null]] || [aString isEqualToString:@"0"]) {
        return nil;
    } else {
        return [aString copy];
    }
}

+ (NSNumber *)parseIntegerNumberFromString:(NSString *)aString {
    if ([aString isKindOfClass:[NSNumber class]])
    {
        return (NSNumber *)aString;
    }
    else if (!aString || [aString isEqual:[NSNull null]])
    {
        return nil;
    }
    else
    {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
        numberFormatter.locale = [GMParser serverLocaleForDecimalNumber];
        return [numberFormatter numberFromString:aString];
    }
}

+ (NSDecimalNumber *)parseDecimalNumberFromString:(NSString *)aString {
    if ([aString isKindOfClass:[NSNumber class]]) {
        NSNumber *parsedNumber = [GMParser parseIntegerNumberFromString:aString];
        return [NSDecimalNumber decimalNumberWithDecimal:parsedNumber.decimalValue];
    }
    else if (![aString isKindOfClass:[NSString class]] ||
        !aString || [aString isEqual:[NSNull null]]) {
        return nil;
    }
    else {
        return [NSDecimalNumber decimalNumberWithString:aString
                                                 locale:[GMParser serverLocaleForDecimalNumber]];
    }
}

+ (NSDate *)parseDateFromString:(NSString *)aString {
    if (!aString || [aString isEqual:[NSNull null]])
    {
        return nil;
    }
    else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[GMParser dateFormat]];
        return [dateFormatter dateFromString:aString];
    }
}

+ (BOOL)parseBooleanFromString:(NSString *)aString {
    if (!aString || [aString isEqual:[NSNull null]])
    {
        return NO;
    }
    else
    {
        return [aString boolValue];
    }
}

+ (NSURL *)parseURLFromString:(NSString *)aString {
    if (!aString || [aString isEqual:[NSNull null]])
    {
        return nil;
    }
    else
    {
        NSURL *url = [NSURL URLWithString:aString];
        if (!url) {
            url = [NSURL fileURLWithPath:aString];
        }
        return url;
    }
}

+ (NSArray *)parseArrayFromComplexObject:(id)anObject {
    if ([anObject isKindOfClass:[NSArray class]]) {
        return anObject;
    } else if ([anObject isKindOfClass:[NSDictionary class]]) {
        return @[anObject];
    } else {
        return nil;
    }
}

#pragma mark - Formatters
+ (NSString *)dateFormat {
    // !!!: Set here the date forma returned by the server
    return @"YYYY-MM-dd HH:mm:ss";
}

+ (NSLocale *)serverLocaleForDecimalNumber {
    return [NSLocale localeWithLocaleIdentifier:@"en_US"];
}

+ (id)secureObject:(id)object {
    if ([object isKindOfClass:[NSDate class]]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:[GMParser dateFormat]];
        return [dateFormatter stringFromDate:(NSDate *)object];
    }
    
    if (object == nil) {
        return [NSNull null];
    }
    
    return object;
}

@end
