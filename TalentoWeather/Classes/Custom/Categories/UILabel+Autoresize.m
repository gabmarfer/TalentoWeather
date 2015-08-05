//
//  UILabel+Autoresize.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "UILabel+Autoresize.h"

@implementation UILabel (Autoresize)

- (void)autoresizeLabelWithText:(NSString *)text {
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    CGSize expectedLabelSize = [text boundingRectWithSize:maximumLabelSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName : self.font,
                                                            NSForegroundColorAttributeName: self.textColor,
                                                            }
                                                  context:nil].size;;
    // Adjust the label to the expected height.
    CGRect expectedFrame = self.frame;
    expectedFrame.size.height = ceilf(expectedLabelSize.height);
    self.frame = expectedFrame;
    
    self.text = text;
}

- (void)autoresizeLabelWithAttributedText:(NSAttributedString *)text {
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    CGSize expectedLabelSize = [text boundingRectWithSize:maximumLabelSize
                                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesLineFragmentOrigin
                                                  context:nil].size;
    // Adjust the label to the expected height
    CGRect expectedFrame = self.frame;
    expectedFrame.size.height = ceilf(expectedLabelSize.height);
    self.frame = expectedFrame;
    
    self.attributedText = text;
}


@end
