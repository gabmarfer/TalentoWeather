//
//  GMSpinnerView.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "GMSpinnerView.h"
@import QuartzCore;

static CGSize const GMSpinnerViewSize = {120.0f, 120.0f};
static NSString * const GMSpinnerImageName = @"logo";
static CGFloat const GMSpinnerViewOpacityLevel = 0.8f;

@interface GMSpinnerView ()
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIImage *imgSpinner;
@property (strong, nonatomic) UILabel *lblMessage;
@end

@implementation GMSpinnerView
@synthesize textColor = _textColor, textFont = _textFont, bgColor = _bgColor;

+ (instancetype)spinnerCenteredInView:(UIView *)aView {
    GMSpinnerView *spinnerView = [GMSpinnerView spinnerView];
    spinnerView.center = CGPointMake(CGRectGetMidX(aView.bounds), CGRectGetMidY(aView.bounds));
    return spinnerView;
}

+ (instancetype)spinnerView {
    GMSpinnerView *spinnerView = [[GMSpinnerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f,
                                                                                 GMSpinnerViewSize.width, GMSpinnerViewSize.height)];
    spinnerView.hidden = YES;
    return spinnerView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_setupView];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self p_setupView];
}

#pragma mark - Accessors
- (UIImage *)imgSpinner {
    if (!_imgSpinner) {
        _imgSpinner = [UIImage imageNamed:GMSpinnerImageName];
    }
    return _imgSpinner;
}

- (UIColor *)bgColor {
    if (!_bgColor) {
        _bgColor = [UIColor clearColor];
    }
    return _bgColor;
}

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor whiteColor];
    }
    return _textColor;
}

- (UIFont *)textFont {
    if (!_textFont) {
        _textFont = [UIFont systemFontOfSize:13.0f];
    }
    return _textFont;
}

#pragma mark - Setters
- (void)setMessage:(NSString *)message {
    if (!_message)
    {
        // Draw a transparent container to assure that the text is visible
        self.backgroundColor = [UIColor blackColor];
        self.opaque = NO;
        self.layer.opacity = GMSpinnerViewOpacityLevel;
        self.layer.cornerRadius = 6.0f;
        self.layer.masksToBounds = YES;
        
        // Go up the imageView a litte bit
        CGRect imgViewFrame = self.imgView.frame;
        imgViewFrame.origin.y -= 8.0f;
        self.imgView.frame = imgViewFrame;
    }
    
    // Set the message
    _message = [message copy];
    
    // Set the text
    self.lblMessage.text = message;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.lblMessage.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    
    self.lblMessage.font = textFont;
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    
    self.backgroundColor = bgColor;
}

#pragma mark - Setup view
- (void)p_setupView {
    self.backgroundColor = self.bgColor;
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    CGFloat margin = 5.0f;
    CGFloat lblHeight = 21.0f;
    _lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(margin, CGRectGetHeight(self.bounds) - margin - lblHeight,
                                                           CGRectGetWidth(self.bounds) - margin*2.0f, lblHeight)];
    self.lblMessage.font = self.textFont;
    self.lblMessage.textColor = self.textColor;
    self.lblMessage.textAlignment = NSTextAlignmentCenter;
    self.lblMessage.lineBreakMode = NSLineBreakByTruncatingTail;
    self.lblMessage.text = self.message;
    [self addSubview:self.lblMessage];
    
    CGSize imgViewSize = CGSizeMake(44.0f, 44.0f);
    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.bounds) - imgViewSize.width/2.0f, CGRectGetMidY(self.bounds) - imgViewSize.height/2.0f,
                                                             imgViewSize.width, imgViewSize.height)];
    self.imgView.contentMode = UIViewContentModeScaleAspectFit;
    self.imgView.clipsToBounds = YES;
    self.imgView.image = self.imgSpinner;
    [self addSubview:self.imgView];
}

#pragma mark - Public methods
- (void)startAnimatingWithMessage:(NSString *)aMessage allowUserInteraction:(BOOL)allowUserInteraction {
    if (!allowUserInteraction) {
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    }
    [self startAnimatingWithMessage:aMessage];
}

- (void)startAnimatingWithMessage:(NSString *)aMessage {
    if (aMessage) {
        self.message = aMessage;
    }
    [self startAnimating];
}

- (void)startAnimating {
    CABasicAnimation *rotation;
    rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotation.fromValue = [NSNumber numberWithFloat:0];
    rotation.toValue = [NSNumber numberWithFloat:(2 * M_PI)];
    rotation.duration = 1.2f; // Speed
    rotation.repeatCount = HUGE_VALF; // Repeat forever
    [self.imgView.layer removeAllAnimations];
    [self.imgView.layer addAnimation:rotation forKey:@"Spin"];
    
    self.hidden = NO;
}

- (void)stopAnimating {
    [self.imgView.layer removeAllAnimations];
    self.hidden = YES;
    
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }
}

- (BOOL)isAnimating {
    return (![self isHidden]);
}

@end
