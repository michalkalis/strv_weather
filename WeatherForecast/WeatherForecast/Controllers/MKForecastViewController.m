//
//  MKForecastViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKForecastViewController.h"
#import "MKSettingsViewController.h"
#import "MKTabBarController.h"
#import "MKForecastCell.h"

#import "MKCoreDataManager.h"
#import "MKWeatherAPIClient.h"
#import "MKWeather.h"
#import "MKLocation.h"

#import "NSDate+MKUtils.h"
#import "UITableView+MKEmptyCells.h"

NSString * const MKForecastCellIdentifier = @"MKForecastCellIdentifier";

@interface MKForecastViewController () <UITableViewDataSource>

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSArray *sortedForecasts;

@end

@implementation MKForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView hideEmptyCells];
    
    self.selectedLocation = [[MKCoreDataManager sharedManager] fetchCurrentLocationObject];
    
    self.sortedForecasts = [self sortForecasts];
    
    [self updateTitle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - Auxiliary

- (NSArray *)sortForecasts {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    return [self.selectedLocation.forecasts sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (void)updateTitle {
    self.title = self.selectedLocation.city;
}

- (void)showActivityIndicator {
    self.tableView.hidden = YES;
    self.activityIndicator.hidden = NO;
    
    [self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator {
    self.tableView.hidden = NO;
    self.activityIndicator.hidden = YES;
    
    [self.activityIndicator stopAnimating];
}

#pragma mark - Notifications

- (void)locationStartedUpdating:(NSNotification *)__unused notification {
    [self showActivityIndicator];
}

- (void)updateWeatherData:(NSNotification *)notification {
    [self hideActivityIndicator];
    
    MKLocation *location = notification.object;
    self.selectedLocation = location;
    
    [self.tableView reloadData];
    self.sortedForecasts = [self sortForecasts];
    [self updateTitle];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedLocation.forecasts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKForecastCell *cell = [tableView dequeueReusableCellWithIdentifier:MKForecastCellIdentifier];
    
    MKWeather *weather = self.sortedForecasts[indexPath.row];
    
    cell.weatherIcon.image = [weather weatherImageFromTextualDescription];
    cell.dayLabel.text = [weather.date weekDayDescription];
    cell.weatherTextLabel.text = weather.textualDescription;
    cell.temperatureLabel.text = [weather temperatureWithDegreesInUnitsOfTemperature:self.unitsOfTemperature];
    
    return cell;
}

@end
