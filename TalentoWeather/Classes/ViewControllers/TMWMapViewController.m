//
//  TMWMapViewController.m
//  TalentoWeather
//
//  Created by gabmarfer on 04/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWMapViewController.h"
// Utils
@import MapKit;
#import "TalentoWeatherUtils.h"
#import "AppDelegate.h"
#import "GMNoticeView.h"
#import "UIViewController+HUD.h"
// ViewControllers
#import "TMWHistoricViewController.h"
#import "TMWDetailViewController.h"
// Models
#import "TMWWeatherManager.h"

static NSString * const TMWMapAnnotationIdentifier = @"TMWMapAnnotation";
static NSString * const TMWMapAnnotionLeftImage = @"ic_thermo";
static NSString * const TMWMapAnnotionRightImage = @"ic_arrow_right";

static NSString * const TMWSegueMapToDetailIdentifier = @"TMWSegueMapToDetail";

@interface TMWMapViewController () <UISearchBarDelegate, UISearchControllerDelegate,
UISearchResultsUpdating, UITableViewDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) UISearchController *searchController;

// The historic search results table view
@property (strong, nonatomic) TMWHistoricViewController *resultsTableController;
@end

@implementation TMWMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setup UI
    [self setupUI];
    
    // Localize
    [self localize];
    
    // Get user location
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate startLocationStandardUpdates];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Manage Notifications
    [[NSNotificationCenter defaultCenter] addObserverForName:TalentoWeatherDidFailUpdatingLocationNotification
                               object:nil
                                queue:[NSOperationQueue mainQueue]
                           usingBlock:^(NSNotification *note) {
                               // Use custom alertView instead of UIAlertController
                               [GMNoticeView showDefaultNoticeWithTitle:NSLocalizedString(@"alert_title_warning", nil)
                                                                message:NSLocalizedString(@"alert_message_location_disabled", nil)
                                                             noticeType:GMNoticeViewTypeWarning
                                                             completion:nil];
                           }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:TalentoWeatherDidFailUpdatingLocationNotification
                                                  object:nil];
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
    // Setup Map
    self.mapView.userLocation.title = NSLocalizedString(@"your_location", nil);
    
    // Setup search controller
    _resultsTableController = [[TMWHistoricViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsTableController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    [self.searchController.searchBar sizeToFit];
    self.navigationItem.titleView = self.searchController.searchBar;
    
    // We want to be the delegate for the resultsTableViewController
    self.resultsTableController.tableView.delegate = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    
    self.definesPresentationContext = YES; // know where you want UISearchController to be displayed
}

#pragma mark --- Localize
- (void)localize {
    
}

#pragma mark - Web services
#pragma mark --- Search a geo point
- (void)requestSearchGeoPointWithQuery:(NSString *)query {
    // Hides search controller
    self.searchController.active = NO;

    [self showHud];
    
    __weak TMWMapViewController *weakSelf = self;
    TMWWeatherManager *weatherManager = [TMWWeatherManager sharedManager];
    [weatherManager requestGetGeoPointWithQuery:query
                                          block:^(TMWGeoPoint *geoPoint, NSError *error) {
                                              TMWMapViewController *strongSelf = weakSelf;
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  [strongSelf hideHud];
                                                  
                                                  if (geoPoint && !error)
                                                  {
                                                      // Firstly, add to the historic searches
                                                      [weatherManager addHistoricSearch:geoPoint];
                                                      
                                                      // Secondly, center on map
                                                      [strongSelf p_centerMapWithGeoPoint:geoPoint];
                                                  }
                                                  else
                                                  {
                                                      // Use custom alertView instead of UIAlertController
                                                      [GMNoticeView showDefaultNoticeWithTitle:NSLocalizedString(@"alert_title_error", nil)
                                                                                       message:error.localizedDescription
                                                                                    noticeType:GMNoticeViewTypeError
                                                                                    completion:nil];
                                                  }
                                                  
                                              });
                                          }];
}

#pragma mark - Supplementary methods
#pragma mark --- Private methods
- (void)p_centerMapWithGeoPoint:(TMWGeoPoint *)geoPoint {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:geoPoint.latitude.doubleValue
                                                      longitude:geoPoint.longitude.doubleValue];
    CLLocationDistance distance = 100;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, distance, distance);
    [self.mapView setRegion:region animated:YES];
    
    // Add annotation
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = location.coordinate;
    annotation.title = geoPoint.name;
    annotation.subtitle = geoPoint.countryName;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - Actions

#pragma mark - Delegates
#pragma mark --- UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length > 0) {
        [self requestSearchGeoPointWithQuery:searchBar.text];
    }
}

#pragma mark --- UISearchControllerDelegate 
// Those methods are included just to show how to responde to UISearchController events

- (void)presentSearchController:(UISearchController *)searchController {
    // Implement this method if the default presentation is not adequate for your purposes.
}

- (void)willPresentSearchController:(UISearchController *)searchController {
    // do something before the search controller is presented
}

- (void)didPresentSearchController:(UISearchController *)searchController {
    // do something after the search controller is presented
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    // do something before the search controller is dismissed
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    // do something after the search controller is dismissed
}

#pragma mark --- UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    TMWHistoricViewController *historicVC = (TMWHistoricViewController *)self.searchController.searchResultsController;
    historicVC.results = [TMWWeatherManager sharedManager].searches;
    [historicVC.tableView reloadData];
}

#pragma mark --- UITableViewDelegate
// This is the delegate for the historic searches tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // If a user select one point, center it on map
    TMWGeoPoint *selectedPoint = self.resultsTableController.results[indexPath.row];
    self.searchController.active = NO;
    [self p_centerMapWithGeoPoint:selectedPoint];
}

#pragma mark --- MapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    // If the annotation is the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:TMWMapAnnotationIdentifier];
        if (!pinView) {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                      reuseIdentifier:TMWMapAnnotationIdentifier];
            pinView.pinColor =MKPinAnnotationColorRed;
            pinView.animatesDrop = YES;
            pinView.canShowCallout = YES;
            
            // Add a detail accessory disclosure
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton setImage:[UIImage imageNamed:TMWMapAnnotionRightImage] forState:UIControlStateNormal];
            rightButton.tintColor = [UIColor ownMainColor];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = rightButton;
            
            // Add a custom image to the left side of the callout.
            UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:TMWMapAnnotionLeftImage]];
            myCustomImage.tintColor = [UIColor ownMainColor];
            pinView.leftCalloutAccessoryView = myCustomImage;
        }
        else {
            pinView.annotation = annotation;
        }
        
        return pinView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    // Get the historic geopoint selected
    MKPointAnnotation *annotation = view.annotation;
    TMWGeoPoint *selectedGeoPoint = [[TMWWeatherManager sharedManager] historicGeoPointWithLatitude:@(annotation.coordinate.latitude)
                                                                                          longitude:@(annotation.coordinate.longitude)];

    if (selectedGeoPoint)
    {
        // Segue to Detail view controller
        [self performSegueWithIdentifier:TMWSegueMapToDetailIdentifier sender:selectedGeoPoint];

    }
    else
    {
        // Use custom alertView instead of UIAlertController
        [GMNoticeView showDefaultNoticeWithTitle:NSLocalizedString(@"alert_title_error", nil)
                                         message:NSLocalizedString(@"alert_message_no_weather_found", nil)
                                      noticeType:GMNoticeViewTypeError
                                      completion:nil];
    }
}


 #pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:TMWSegueMapToDetailIdentifier]) {
        TMWDetailViewController *detailVC = (TMWDetailViewController *)segue.destinationViewController;
        detailVC.selectedGeopoint = (TMWGeoPoint *)sender;
    }
}

@end
