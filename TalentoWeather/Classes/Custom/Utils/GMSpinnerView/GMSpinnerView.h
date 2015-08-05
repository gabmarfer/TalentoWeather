//
//  GMSpinnerView.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSpinnerView : UIView
/*!
 * The view background color that will be shown if there is a message
 */
@property (strong, nonatomic) UIColor *bgColor;

/*!
 * The text color for the optional message
 */
@property (strong, nonatomic) UIColor *textColor;

/*!
 * The text font for the optional message
 */
@property (strong, nonatomic) UIFont *textFont;

/*!
 * The optional message shown below the spinner image
 */
@property (copy, nonatomic) NSString *message;

/**
 * Create a spinnerView which frame is centered to the given view
 *
 * @param aView A view that will contain the spinner
 * @return An instance of the SpinnerView
 */
+ (instancetype)spinnerCenteredInView:(UIView *)aView;

/**
 * Create a spinnerView
 *
 * @param
 * @return An instance of the SpinnerView
 */
+ (instancetype)spinnerView;

/**
 * Show the spinner with an optional message
 *
 * @param aMessage An optional message to show to the user
 * @param allowUserInteraction YES if the screen interactions should be disabled while the spinner is animating
 * @return
 */
- (void)startAnimatingWithMessage:(NSString *)aMessage allowUserInteraction:(BOOL)allowUserInteraction;

/**
 * Show the spinner with an optional message
 *
 * @param aMessage An optional message to show to the user
 * @return
 */
- (void)startAnimatingWithMessage:(NSString *)aMessage;

/**
 * Show the spinner
 *
 * @param
 * @return
 */
- (void)startAnimating;

/**
 * Stop the spinner
 *
 * @discussion This method enables screen user interaction if it was disabled previosly
 * @param
 * @return
 */
- (void)stopAnimating;

/**
 * Check if the spinner is animating
 *
 * @param
 * @return YES if the spinner is visible and is animating
 */
- (BOOL)isAnimating;
@end
