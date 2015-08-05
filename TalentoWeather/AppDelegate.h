//
//  AppDelegate.h
//  TalentoWeather
//
//  Created by gabmarfer on 04/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocationManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;

// Location
- (void)startLocationStandardUpdates;

@end

