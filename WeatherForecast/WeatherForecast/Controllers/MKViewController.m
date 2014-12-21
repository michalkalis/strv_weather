//
//  MKViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 17/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKViewController.h"
#import "MKTabBarController.h"
#import "MKLocationViewController.h"

#import "NSNotificationCenter+MKOneObserver.h"

@implementation MKViewController

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateTypesFromSettings];
    
    [NSNotificationCenter addToDefaultCenterObserver:self name:MKTabBarControllerDidStartUpdatingLocationNotification selector:@selector(locationStartedUpdating:) object:nil];
    [NSNotificationCenter addToDefaultCenterObserver:self name:MKTabBarControllerFailedGettingLocationNotification selector:@selector(locationGettingFailed:) object:nil];
    [NSNotificationCenter addToDefaultCenterObserver:self name:MKTabBarControllerDidFetchWeatherDataNotification selector:@selector(updateWeatherData:) object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Observers are not removed when showing modal controllers
    if (!self.presentedViewController) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MKTabBarControllerDidStartUpdatingLocationNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MKTabBarControllerFailedGettingLocationNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MKTabBarControllerDidFetchWeatherDataNotification object:nil];
    }
}

#pragma mark - Auxiliary

- (void)updateTypesFromSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Celsius or Fahrenheit
    NSNumber *unitOfTemperatureObject = [userDefaults objectForKey:MKSettingsViewControllerUnitsOfTemperatureKey];
    if (!unitOfTemperatureObject) {
        self.unitsOfTemperature = MKWeatherUnitsOfTemperatureTypeCelsius;
    }
    else {
        self.unitsOfTemperature = [unitOfTemperatureObject integerValue];
    }
    
    // Kilometers or miles
    NSNumber *unitsOfLengthObject = [userDefaults objectForKey:MKSettingsViewControllerUnitsOfLengthKey];
    if (!unitsOfLengthObject) {
        self.unitsOfLength = MKWeatherUnitsOfLengthTypeKilometers;
    }
    else {
        self.unitsOfLength = [unitsOfLengthObject integerValue];
    }
}

#pragma mark - Notifications

- (void)locationStartedUpdating:(NSNotification *)__unused notification {}

- (void)locationGettingFailed:(NSNotification *)__unused notification {}

- (void)updateWeatherData:(NSNotification *)notification {}

- (void)didSelectLocation:(NSNotification *)notification {}

@end
