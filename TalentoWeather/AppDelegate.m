//
//  AppDelegate.m
//  TalentoWeather
//
//  Created by gabmarfer on 04/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "AppDelegate.h"
// Utils
@import CoreLocation;
#import "AFNetworkActivityLogger.h"
#import "TalentoWeatherUtils.h"
#import <Google/Analytics.h>

@interface AppDelegate () <CLLocationManagerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Loggin web services calls
    [[AFNetworkActivityLogger sharedLogger] startLogging];
    
    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelError;  // remove before app release
    
    // Customize theme
    [self customizeTheme];
    
    return YES;
}

#pragma mark - Theme
- (void)customizeTheme {
    [UINavigationBar appearance].tintColor = [UIColor ownMainColor];
}

#pragma mark - Location services
- (void)startLocationStandardUpdates {
    if ([CLLocationManager locationServicesEnabled]) {
        // Create the location manager if this object does not already have one
        if (self.locationManager == nil) {
            self.locationManager = [[CLLocationManager alloc] init];
        }
        
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        
        // Set a movement threshold for new events
        self.locationManager.distanceFilter = 500; // meters
        
        // Check for iOS 8
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        
        [self.locationManager startUpdatingLocation];
    } else {
        // Post a notification
        [[NSNotificationCenter defaultCenter] postNotificationName:TalentoWeatherDidFailUpdatingLocationNotification
                                                            object:nil
                                                          userInfo:nil];
    }
}

- (void)startLocationSignificantChangeUpdates {
    // Create the location manager if this object does not
    // already have one.
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringSignificantLocationChanges];
}

// Location delegate method for systems
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's relatively recent event, turn off updates to save power.
    [self locationDidUpdateWithLocation:[locations lastObject]];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    TMWLog(@"%@", error);
    // Post a notification
    [[NSNotificationCenter defaultCenter] postNotificationName:TalentoWeatherDidFailUpdatingLocationNotification
                                                        object:nil
                                                      userInfo:@{TalentoWeatherDidFailUpdatingLocationNotification: error}];
}

/**
 * Manage location changes
 */
- (void)locationDidUpdateWithLocation:(CLLocation *)location
{
    // Firstly stop the service
    [self.locationManager stopUpdatingLocation];
    
    // If the event is recent, do something with it
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = eventDate.timeIntervalSinceNow;
    if (fabs(howRecent) < 15.0)
    {
        TMWLog(@"Latitude %+.6f, Longitude %+.6f\n", location.coordinate.latitude, location.coordinate.longitude);
        // Post a notification
        [[NSNotificationCenter defaultCenter] postNotificationName:TalentoWeatherDidUpdateLocationNotification
                                                            object:nil
                                                          userInfo:@{TalentoWeatherDidUpdateLocationNotification: location}];
    }
}

#pragma mark - Application lifecycle
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
