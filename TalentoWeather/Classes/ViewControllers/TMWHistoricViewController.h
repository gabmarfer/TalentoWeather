//
//  TMWHistoricViewController.h
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

/*
 * This class is used to show the historic searches while the UISearchBar is the first responder
 */

#import <UIKit/UIKit.h>

@interface TMWHistoricViewController : UITableViewController
@property (strong, nonatomic) NSArray *results;
@end
