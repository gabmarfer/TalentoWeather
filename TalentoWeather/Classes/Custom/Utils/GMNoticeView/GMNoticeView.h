//
//  GMNoticeView.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSUInteger, GMNoticeViewType) {
    GMNoticeViewTypeMessage,
    GMNoticeViewTypeSuccess,
    GMNoticeViewTypeWarning,
    GMNoticeViewTypeError,
};

@interface GMNoticeView : UIView
@property (nonatomic, getter = isShowing) BOOL showing;

/*
 * Class initializer for fast showing
 */
+ (void)showDefaultNoticeWithTitle:(NSString *)title
                           message:(NSString *)message
                              noticeType:(GMNoticeViewType)noticeType
                          completion:(void (^)())completion;

/*
 * Designated initializer
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                   noticeType:(GMNoticeViewType)noticeType;

/*
 * Show the noticeView
 */
- (void)showNoticeWithCompletion:(void (^)())completion;
@end
