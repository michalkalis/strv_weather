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
#import "MKWeatherCell.h"

#import "MKCoreDataManager.h"
#import "MKWeatherAPIClient.h"
#import "MKWeather.h"
#import "MKLocation.h"

#import "NSDate+MKUtils.h"
#import "UITableView+MKEmptyCells.h"

static NSString * const MKWeatherCellIdentifier = @"MKWeatherCellIdentifier";

@interface MKForecastViewController () <UITableViewDataSource>

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSArray *sortedForecasts;

@end

@implementation MKForecastViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // Needs to be set programmatically as it's not working via IB
        UIImage *image = [[UIImage imageNamed:@"Forecast"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSel = [[UIImage imageNamed:@"Forecast_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *forecastTabItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Forecast", @"General") image:image selectedImage:imageSel];
        
        self.tabBarItem = forecastTabItem;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView hideEmptyCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.selectedLocation = [[MKCoreDataManager sharedManager] fetchSelectedLocationObject];
    self.sortedForecasts = [self sortForecasts];
    
    [self updateUI];
}

#pragma mark - Auxiliary

- (NSArray *)sortForecasts {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    return [self.selectedLocation.forecasts sortedArrayUsingDescriptors:@[sortDescriptor]];
}

- (void)updateTitle {
    [self.navigationItem setTitle:self.selectedLocation.city];
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

- (void)updateUI {
    [self.tableView reloadData];
    [self updateTitle];
}

#pragma mark - Notifications

- (void)locationStartedUpdating:(NSNotification *)__unused notification {
    [self showActivityIndicator];
}

- (void)updateWeatherData:(NSNotification *)notification {
    [self hideActivityIndicator];
    
    MKLocation *location = notification.object;
    self.selectedLocation = location;
    
    self.sortedForecasts = [self sortForecasts];
    [self updateUI];
}

- (void)didSelectLocation:(NSNotification *)notification {
    self.selectedLocation = notification.object;;
    
    [self updateUI];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedLocation.forecasts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:MKWeatherCellIdentifier];
    
    MKWeather *weather = self.sortedForecasts[indexPath.row];
    
    cell.weatherIcon.image = [weather weatherImageFromTextualDescription];
    cell.titleLabel.text = [weather.date weekDayDescription];
    cell.weatherTextLabel.text = weather.textualDescription;
    cell.temperatureLabel.text = [weather temperatureWithDegreesInUnitsOfTemperature:self.unitsOfTemperature];
    
    return cell;
}

@end
