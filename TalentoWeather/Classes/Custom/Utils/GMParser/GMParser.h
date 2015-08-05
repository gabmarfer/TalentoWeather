//
//  GMParser.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMParser : NSObject

#pragma mark - Parsers

/**
 * Parse a NSString
 *
 * @param aString The received string
 * @return A NSString object or nil
 */
+ (NSString *)parseStringFromString:(NSString *)aString;

/**
 * Parse a NSNumber from a String
 *
 * @param aString The received string
 * @return a NSNumber or nil
 */
+ (NSNumber *)parseIntegerNumberFromString:(NSString *)aString;

/**
 * Parse a NSDecimalNumber from a String
 *
 * @param aString The received string
 * @return a NSDecimalNumber or nil
 */
+ (NSDecimalNumber *)parseDecimalNumberFromString:(NSString *)aString;

/**
 * Parse a NSDate from a String
 *
 * @param aString The received string
 * @return a NSDate or nil
 */
+ (NSDate *)parseDateFromString:(NSString *)aString;

/**
 * Parse a BOOL from a String
 *
 * @discussion This method initialize the BOOL to NO if no value can be
 * parsed
 * @param aString The received string
 * @return a BOOL
 */
+ (BOOL)parseBooleanFromString:(NSString *)aString;

/**
 * Parse a NSURL from a String
 *
 * @param aString The received string
 * @return a NSURL or nil
 */
+ (NSURL *)parseURLFromString:(NSString *)aString;

/**
 * Parse a NSArray from a received object
 *
 * @discussion This method is indicated for web services that return
 * a dictionary for a single object and an array for a list of objects for the
 * same output param
 * @param anObject An object to be parsed (can be a NSDictionary or a NSArray)
 * @return A NSArray with at least one object or nil
 */
+ (NSArray *)parseArrayFromComplexObject:(id)anObject;

/**
 * Add objects to collections in a secure way to avoid crashes
 *
 * @discussion If the object is nil returns [NSNull null]
 * or if the object is a NSDate returns a formatted string
 * @param object The object to add to the collection
 * @return id The received object or [NSNull null]
 */
+ (id)secureObject:(id)object;
@end
