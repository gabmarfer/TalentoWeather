//
//  UILabel+Autoresize.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Autoresize)
- (void)autoresizeLabelWithText:(NSString *)text;
- (void)autoresizeLabelWithAttributedText:(NSAttributedString *)text;
@end
