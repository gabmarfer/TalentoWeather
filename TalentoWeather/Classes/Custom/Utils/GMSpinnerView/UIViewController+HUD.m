//
//  UIViewController+HUD.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <objc/runtime.h>
#import "GMSpinnerView.h"

@implementation UIViewController (HUD)
@dynamic spinnerView;

- (void)setSpinnerView:(GMSpinnerView *)spinnerView {
    objc_setAssociatedObject(self, @selector(spinnerView), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GMSpinnerView *)spinnerView {
    return objc_getAssociatedObject(self, @selector(spinnerView));
}

- (void)showHud {
    return [self showHudWithMessage:nil];
}

- (void)showHudWithMessage:(NSString *)aMessage {
    return[self showHudWithMessage:aMessage allowUserInteraction:YES];
}

- (void)showHudWithMessage:(NSString *)aMessage allowUserInteraction:(BOOL)allowUserInteraction {
    if (!self.spinnerView) {
        self.spinnerView = [GMSpinnerView spinnerCenteredInView:self.view];
        [self.view addSubview:self.spinnerView];
    }
    [self.spinnerView startAnimatingWithMessage:aMessage allowUserInteraction:allowUserInteraction];
}

- (void)hideHud {
    if (self.spinnerView) {
        [self.spinnerView stopAnimating];
    }
}
@end
