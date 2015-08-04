//
//  TMWMapViewController.m
//  TalentoWeather
//
//  Created by gabmarfer on 04/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWMapViewController.h"
@import MapKit;

@interface TMWMapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation TMWMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup UI
    [self setupUI];
    
    // Localize
    [self localize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- Orientation
-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

#pragma mark --- SetupUI
- (void)setupUI {
    
}

#pragma mark --- Localize
- (void)localize {
    
}

#pragma mark - Web services

#pragma mark - Supplementary methods

#pragma mark - Actions

/*
 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
