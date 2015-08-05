//
//  TMWDetailViewController.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMWGeoPoint;

@interface TMWDetailViewController : UIViewController
@property (strong, nonatomic) TMWGeoPoint *selectedGeopoint;
@end
