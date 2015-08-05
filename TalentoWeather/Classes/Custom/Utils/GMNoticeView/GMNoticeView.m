//
//  GMNoticeView.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "GMNoticeView.h"
#import "AppDelegate.h"
#import "UILabel+Autoresize.h"

static CGFloat const GMNoticeViewDelay = 2.0f;
static CGFloat const GMNoticeViewHeight = 104.0f;
static CGSize const GMNoticeViewIconSize = {24.0f, 24.0f};

static NSString * const GMNoticeViewIconWarning = @"NotificationBackgroundWarningIcon";
static NSString * const GMNoticeViewIconError = @"NotificationBackgroundErrorIcon";
static NSString * const GMNoticeViewIconSuccess = @"NotificationBackgroundSuccessIcon";

@interface GMNoticeView ()
@property (strong, nonatomic) UIColor *bgColor;
@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *textColor;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *message;
@property (assign, nonatomic) CGFloat duration;
@property (strong, nonatomic) UILabel *lblText;
@property (assign, nonatomic) GMNoticeViewType noticeType;
@property (strong, nonatomic) UIImageView *imgViewIcon;
@end

@implementation GMNoticeView
@synthesize bgColor = _bgColor;

+ (void)showDefaultNoticeWithTitle:(NSString *)title
                           message:(NSString *)message
                        noticeType:(GMNoticeViewType)noticeType
                        completion:(void (^)())completion {
    GMNoticeView *noticeView = [[self alloc] initWithTitle:title message:message noticeType:noticeType];
    [noticeView showNoticeWithCompletion:completion];
}

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                   noticeType:(GMNoticeViewType)noticeType {
    self = [super initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen mainScreen].bounds.size.width, GMNoticeViewHeight)];
    if (self) {
        _title = [title copy];
        _message = [message copy];
        _noticeType = noticeType;
        [self p_setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initWithTitle:message:..."
                                 userInfo:nil];
    return nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_setupView];
}

- (void)p_setupView {
    self.backgroundColor = self.bgColor;
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    CGFloat leftPadding = 10.0f;
    _imgViewIcon = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, CGRectGetMidY(self.bounds) - GMNoticeViewIconSize.height/2.0f,
                                                                 GMNoticeViewIconSize.width, GMNoticeViewIconSize.height)];
    self.imgViewIcon.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    self.imgViewIcon.backgroundColor = [UIColor clearColor];
    self.imgViewIcon.contentMode = UIViewContentModeCenter;
    self.imgViewIcon.clipsToBounds = YES;
    [self addSubview:self.imgViewIcon];
    
    // Only 3 of 4 types show a left icon
    NSString *iconName;
    switch (self.noticeType) {
        case GMNoticeViewTypeWarning:
        {
            iconName = GMNoticeViewIconWarning;
            break;
        }
        case GMNoticeViewTypeError:
        {
            iconName = GMNoticeViewIconError;
            break;
        }
        case GMNoticeViewTypeSuccess:
        {
            iconName = GMNoticeViewIconSuccess;
            break;
        }
            
        default:
            break;
    }
    
    if (iconName) {
        self.imgViewIcon.image = [UIImage imageNamed:iconName];
    }
    
    CGFloat rigthPadding = 24.0f;
    // If there is a left image, take it into account to expand the left margin, otherwise set the default value (20px)
    CGFloat originX = (iconName) ? CGRectGetMaxX(self.imgViewIcon.frame) + 40.0f : rigthPadding;
    _lblText = [[UILabel alloc] initWithFrame:CGRectMake(originX, 0.0f, self.bounds.size.width - (originX + rigthPadding), 21.0f)];
    self.lblText.backgroundColor = [UIColor clearColor];
    self.lblText.numberOfLines = 0;
    self.lblText.textAlignment = NSTextAlignmentLeft;
    self.lblText.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.lblText];
}

#pragma mark - Accessors & Setters
- (UIColor *)bgColor {
    if (!_bgColor) {
        UIColor *aColor;
        switch (self.noticeType) {
            case GMNoticeViewTypeMessage:
            {
                // Gray color
                aColor = [UIColor colorWithRed:0.824 green:0.851 blue:0.867 alpha:1.000];
                break;
            }
            case GMNoticeViewTypeSuccess:
            {
                // Green color
                aColor = [UIColor colorWithRed:0.431 green:0.780 blue:0.369 alpha:1.000];
                break;
            }
            case GMNoticeViewTypeWarning:
            {
                // Yellow color
                aColor = [UIColor colorWithRed:0.843 green:0.757 blue:0.212 alpha:1.000];
                break;
            }
            case GMNoticeViewTypeError:
            {
                // Red color
                aColor = [UIColor colorWithRed:0.800 green:0.200 blue:0.200 alpha:1.000];
                break;
            }
        }
        return aColor;
    }
    return _bgColor;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.backgroundColor = bgColor;
}

- (UIColor *)titleColor {
    if (!_titleColor) {
        UIColor *aColor;
        switch (self.noticeType) {
            case GMNoticeViewTypeMessage:
            {
                aColor = [UIColor colorWithRed:0.447 green:0.486 blue:0.514 alpha:1.000];
                break;
            }
            case GMNoticeViewTypeSuccess:
            {
                aColor = [UIColor whiteColor];
                break;
            }
            case GMNoticeViewTypeWarning:
            {
                aColor = [UIColor colorWithRed:0.282 green:0.275 blue:0.220 alpha:1.000];
                break;
            }
            case GMNoticeViewTypeError:
            {
                aColor = [UIColor whiteColor];
                break;
            }
        }
        return aColor;
    }
    return _titleColor;
}

- (UIFont *)titleFont {
    if (!_titleFont) {
        return [UIFont boldSystemFontOfSize:13.0f];
    }
    return _titleFont;
}

- (UIColor *)textColor {
    if (!_textColor) {
        UIColor *aColor;
        switch (self.noticeType) {
            case GMNoticeViewTypeMessage:
            {
                aColor = [UIColor colorWithRed:0.447 green:0.486 blue:0.514 alpha:1.000];
                break;
            }
            case GMNoticeViewTypeSuccess:
            {
                aColor = [UIColor whiteColor];
                break;
            }
            case GMNoticeViewTypeWarning:
            {
                aColor = [UIColor colorWithRed:0.282 green:0.275 blue:0.220 alpha:1.000];
                break;
            }
            case GMNoticeViewTypeError:
            {
                aColor = [UIColor whiteColor];
                break;
            }
        }
        return aColor;
    }
    return _textColor;
}

- (UIFont *)textFont {
    if (!_textFont) {
        return [UIFont systemFontOfSize:13.0f];
    }
    return _textFont;
}

#pragma mark - Presentation methods
- (void)showNoticeWithCompletion:(void (^)())completion {
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    UIWindow *window = appDelegate.window;
    
    // Prepare view
    [self p_adjustLabel];
    self.frame = [self p_startFrame];
    [window addSubview:self];
    [window bringSubviewToFront:self];
    
    // Show with animation
    self.showing = YES;
    [UIView animateWithDuration:0.6f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.frame = [self p_endFrame];
                     } completion:^(BOOL finished) {
                         CGFloat delay = (self.duration > 0.0f) ? self.duration : GMNoticeViewDelay;
                         [UIView animateWithDuration:0.6f
                                               delay:delay
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              self.frame = [self p_startFrame];
                                          } completion:^(BOOL finished) {
                                              [self removeFromSuperview];
                                              self.showing = NO;
                                              if (completion)
                                                  completion();
                                          }];
                     }];
}

#pragma mark - Private methods
- (void)p_adjustLabel {
    // Resize the view
    CGFloat oldHeight = self.lblText.bounds.size.height;
    [self.lblText autoresizeLabelWithAttributedText:[self p_attributedText]];
    CGFloat newHeight = self.lblText.bounds.size.height;
    
    CGRect endFrame = self.frame;
    CGFloat deltaY = newHeight - oldHeight;
    if (deltaY > 0) {
        endFrame.size.height += deltaY;
    }
    
    self.lblText.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (CGRect)p_startFrame {
    CGRect startFrame = self.frame;
    startFrame.origin.y -= self.frame.size.height;
    return startFrame;
}

- (CGRect)p_endFrame {
    CGRect endFrame = self.frame;
    endFrame.origin.y = 0.0f;
    return endFrame;
}

- (NSAttributedString *)p_attributedText {
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] init];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.minimumLineHeight = 15.0f;
    paragraphStyle.maximumLineHeight = 15.0f;
    paragraphStyle.lineSpacing = 2.0f;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    if (self.title) {
        NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\r", self.title]
                                                                        attributes:@{NSFontAttributeName: self.titleFont,
                                                                                     NSForegroundColorAttributeName: self.titleColor,
                                                                                     NSParagraphStyleAttributeName: paragraphStyle,
                                                                                     }];
        [attrText appendAttributedString:attrTitle];
    }
    
    if (self.message) {
        NSAttributedString *attrMessage = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", self.message]
                                                                        attributes:@{NSFontAttributeName: self.textFont,
                                                                                     NSForegroundColorAttributeName: self.textColor,
                                                                                     NSParagraphStyleAttributeName: paragraphStyle,
                                                                                     }];
        [attrText appendAttributedString:attrMessage];
    }
    
    return attrText;
}

@end
