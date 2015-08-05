//
//  TMWHistoricViewController.m
//  TalentoWeather
//
//  Created by gabmarfer on 05/08/15.
//  Copyright (c) 2015 TalentoMobile. All rights reserved.
//

#import "TMWHistoricViewController.h"
// DataModel
#import "TMWGeoPoint.h"

static NSString * const TMWHistoricCellIdentifier = @"TMWHistoricCell";

@interface TMWHistoricViewController ()

@end

@implementation TMWHistoricViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:TMWHistoricCellIdentifier];
    self.tableView.tableHeaderView = [self headerView];
    self.tableView.layer.opacity = 0.8f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Supplementary methods
- (UIView *)headerView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), 44.0f)];
    headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectInset(headerView.bounds, 10.0f, 10.0f)];
    lblTitle.text = NSLocalizedString(@"historic_searches", nil);
    [headerView addSubview:lblTitle];
    
    return headerView;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TMWHistoricCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    TMWGeoPoint *aGeoPoint = self.results[indexPath.row];
    cell.textLabel.text = aGeoPoint.name;
    
    return cell;
}

@end
