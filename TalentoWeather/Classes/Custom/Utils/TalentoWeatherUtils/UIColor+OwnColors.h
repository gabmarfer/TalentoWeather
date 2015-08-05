//
//  UIColor+OwnColors.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

/**
 * I always use a category of UIColor to define the set of colors
 * that the app uses.
 *
 * There is no need to use it in this test project , but I include
 * to show how to centralize app colors only in one point
 */

#import <UIKit/UIKit.h>

@interface UIColor (OwnColors)

// Example
+ (UIColor *)ownMainColor;

//+ (UIColor *)ownSecondaryColor;
//+ (UIColor *)ownComplementaryColor;
//...
@end
