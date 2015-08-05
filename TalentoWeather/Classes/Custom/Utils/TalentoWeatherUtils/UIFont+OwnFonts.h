//
//  UIFont+OwnFonts.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

/**
 * I always use a category of UIFont to define the set of fonts
 * that the app uses.
 *
 * There is no need to use it in this test project , but I include
 * to show how to centralize app fonts only in one point
 */

#import <UIKit/UIKit.h>

@interface UIFont (OwnFonts)

// Example
+ (UIFont *)ownFontWithSize:(CGFloat)size;

//+ (UIFont *)ownLightFontWithSize:(CGFloat)size;
//+ (UIFont *)ownBoldFontWithSize:(CGFloat)size;
//+ (UIFont *)ownItalicFontWithSize:(CGFloat)size;
//...
@end
