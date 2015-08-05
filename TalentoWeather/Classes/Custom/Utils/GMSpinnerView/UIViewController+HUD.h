//
//  UIViewController+HUD.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMSpinnerView;

@interface UIViewController (HUD)

/*!
 * The spinner view
 */
@property (strong, nonatomic) GMSpinnerView *spinnerView;

/**
 * Show the spinner with an optional message
 *
 * @param aMessage An optional message to show to the user
 * @param allowUserInteraction YES if the screen interactions should be disabled while the spinner is animating
 * @return
 */
- (void)showHudWithMessage:(NSString *)aMessage allowUserInteraction:(BOOL)allowUserInteraction;

/**
 * Show the spinner with an optional message
 *
 * @param aMessage An optional message to show to the user
 * @return
 */
- (void)showHudWithMessage:(NSString *)aMessage;

/**
 * Show the spinner
 *
 * @param
 * @return
 */
- (void)showHud;

/**
 * Hide the spinner
 *
 * @discussion This method enables screen user interaction if it was disabled previosly
 * @param
 * @return
 */
- (void)hideHud;
@end
