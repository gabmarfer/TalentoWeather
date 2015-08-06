//
//  TMWDetailViewController.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWDetailViewController.h"
// Utils
#import "TalentoWeatherUtils.h"
#import "UIViewController+HUD.h"
#import "GMNoticeView.h"
// DataModel
#import "TMWWeatherManager.h"
#import "TMWGeoPoint.h"
#import "TMWPrediction.h"

// Scales of the thermometer view
static NSInteger const TMWDetailMaxTemperatureScale = 50;
static NSInteger const TMWDetailMinTemperatureScale = -10;

@interface TMWDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lblClouds;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperature;
@property (weak, nonatomic) IBOutlet UILabel *lblHumidity;
@property (weak, nonatomic) IBOutlet UILabel *lblWind;
@property (weak, nonatomic) IBOutlet UIView *thermoView;
@property (weak, nonatomic) IBOutlet UILabel *lblMax;
@property (weak, nonatomic) IBOutlet UILabel *lblMin;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintColorViewHeight;

@property (strong, nonatomic) TMWPrediction *selectedPrediction;
@end

@implementation TMWDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup UI
    [self setupUI];
    
    // Localize
    [self localize];
    
    [self requestGetPredictionForGeoPoint:self.selectedGeopoint];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    // Animate filling of thermoView
    // The colorView (within thermoView) will simulate the temperature. Calculate a proportional height depending on
    // the current averague temperature value and the height of the thermoView on screen
    CGFloat colorViewHeight = (self.selectedPrediction.averageTemperature.floatValue * self.thermoView.bounds.size.height) /
    (TMWDetailMaxTemperatureScale - TMWDetailMinTemperatureScale);
    [self.colorView layoutIfNeeded];
    [UIView animateWithDuration:0.6f
                     animations:^{
                         self.constraintColorViewHeight.constant = colorViewHeight;
                         [self.colorView layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:1.5f
                                              animations:^{
                                                  self.colorView.backgroundColor = self.selectedPrediction.temperatureColor;
                                              }];
                         }
                     }];
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
    self.navigationItem.title = self.selectedGeopoint.name;
    
    self.thermoView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.thermoView.layer.borderWidth = 2.0f;
    self.thermoView.layer.cornerRadius = 8.0f;
    self.thermoView.layer.masksToBounds = YES;
    
    // Set default color of thermo view
    self.colorView.backgroundColor = [self.selectedPrediction colorForTemperatureType:TMWPredictionTempTypeFrozen];
}

#pragma mark --- Localize
- (void)localize {
    
}

#pragma mark - Web services
#pragma mark --- Get a prediction
- (void)requestGetPredictionForGeoPoint:(TMWGeoPoint *)geopoint {
    [self showHud];
    __weak TMWDetailViewController *weakSelf = self;
    [[TMWWeatherManager sharedManager] requestGetPredictionForCardinalPoints:geopoint.cardinalPoints
                                                                       block:^(TMWPrediction *prediction, NSError *error) {
                                                                           TMWDetailViewController *strongSelf = weakSelf;
                                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                                               [strongSelf hideHud];
                                                                               
                                                                               if (!error)
                                                                               {
                                                                                   strongSelf.selectedPrediction = prediction;
                                                                                   [strongSelf fillPredictionInfo];
                                                                               }
                                                                               else
                                                                               {
                                                                                   [GMNoticeView showDefaultNoticeWithTitle:NSLocalizedString(@"alert_title_error", nil)
                                                                                                                    message:error.localizedDescription
                                                                                                                 noticeType:GMNoticeViewTypeError
                                                                                                                 completion:^{
                                                                                                                     [strongSelf.navigationController popViewControllerAnimated:YES];
                                                                                                                 }];
                                                                               }
                                                                           });
                                                                       }];
    
}

#pragma mark - Supplementary methods
- (void)fillPredictionInfo {
    self.bgView.alpha = 0.0f;
    self.bgView.image = self.selectedPrediction.temperatureBackgroundImage;
    [UIView animateWithDuration:0.4f
                     animations:^{
                         self.bgView.alpha = 1.0f;
                     }];
    
    self.imgViewIcon.tintColor = self.selectedPrediction.temperatureColor;
    self.imgViewIcon.image = self.selectedPrediction.temperatureIconImage;
    
    self.lblClouds.text = self.selectedPrediction.lastMeasure.clouds;
    
    NSString *strTemperature = [NSString stringWithFormat:@"%@°", self.selectedPrediction.averageTemperature.stringValue];
    self.lblTemperature.text = strTemperature;
    
    NSString *strHumidity = [NSString stringWithFormat:NSLocalizedString(@"humidity_%@", nil), self.selectedPrediction.lastMeasure.humidity.stringValue];
    self.lblHumidity.text = strHumidity;
    
    NSString *strWindSpeed = [NSString stringWithFormat:NSLocalizedString(@"windspeed_%@", nil), self.selectedPrediction.lastMeasure.windSpeed.stringValue];
    self.lblWind.text = strWindSpeed;
    
    // Set values of scale
    self.lblMax.text = [NSString stringWithFormat:@"%ld°", TMWDetailMaxTemperatureScale];
    self.lblMin.text = [NSString stringWithFormat:@"%ld°", TMWDetailMinTemperatureScale];
}

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
