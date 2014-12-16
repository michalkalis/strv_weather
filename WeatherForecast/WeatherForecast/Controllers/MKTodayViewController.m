//
//  MKTodayViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKTodayViewController.h"
#import "MKTabBarController.h"

#import "MKWeatherAPIClient.h"
#import "MKWeather.h"
#import "MKLocation.h"

#import "NSNotificationCenter+MKOneObserver.h"

@interface MKTodayViewController ()

@property (nonatomic, strong) MKWeather *currentWeather;
@property (nonatomic, strong) MKLocation *selectedLocation;

@end

@implementation MKTodayViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [NSNotificationCenter addToDefaultCenterObserver:self name:MKTabBarControllerDidFetchWeatherDataNotification selector:@selector(updateWeatherData:) object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MKTabBarControllerDidFetchWeatherDataNotification object:nil];
}

#pragma mark - Auxiliary

- (void)updateUI {
    
}

- (void)fetchWeatherDataForLocation:(MKLocation *)location {
    [[MKWeatherAPIClient sharedClient] fetchWeatherDataAtLocation:location withBlock:^(MKLocation *location, NSError *error) {
        self.currentWeather = location.currentWeather;
        
        [self updateUI];
    }];
}

#pragma mark - Notifications

- (void)updateWeatherData:(NSNotification *)notification {
    MKLocation *location = notification.object;
    self.selectedLocation = location;
    self.currentWeather = self.selectedLocation.currentWeather;
    
    [self updateUI];
}

@end
