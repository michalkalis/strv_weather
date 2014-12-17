//
//  MKTodayViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKTodayViewController.h"
#import "MKSettingsViewController.h"
#import "MKTabBarController.h"

#import "MKWeatherAPIClient.h"
#import "MKWeather.h"
#import "MKLocation.h"

#import "NSNotificationCenter+MKOneObserver.h"

static NSString * const MKTodayViewControllerComment = @"Today";

@interface MKTodayViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityLabelCenterXConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;

@property (nonatomic) MKWeatherUnitsOfTemperatureType unitsOfTemperature;
@property (nonatomic) MKWeatherUnitsOfLengthType unitsOfLength;
@property (nonatomic, strong) MKWeather *currentWeather;
@property (nonatomic, strong) MKLocation *selectedLocation;

@end

@implementation MKTodayViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Today", MKTodayViewControllerComment);
    
    self.cityLabel.adjustsFontSizeToFitWidth = YES;
    
    // Update UI elements with data from web service
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setTypesFromSettings];
    
    [NSNotificationCenter addToDefaultCenterObserver:self name:MKTabBarControllerDidStartUpdatingLocationNotification selector:@selector(locationStartedUpdating:) object:nil];
    [NSNotificationCenter addToDefaultCenterObserver:self name:MKTabBarControllerDidFetchWeatherDataNotification selector:@selector(updateWeatherData:) object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MKTabBarControllerDidStartUpdatingLocationNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MKTabBarControllerDidFetchWeatherDataNotification object:nil];
}

#pragma mark - Auxiliary

- (void)setTypesFromSettings {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Celsius or Fahrenheit
    NSNumber *unitOfTemperatureObject = [userDefaults objectForKey:MKSettingsViewControllerUnitsOfTemperatureKey];
    if (!unitOfTemperatureObject) {
        self.unitsOfTemperature = MKWeatherUnitsOfTemperatureTypeCelsius;
        
        [userDefaults setObject:@(MKWeatherUnitsOfTemperatureTypeCelsius) forKey:MKSettingsViewControllerUnitsOfTemperatureKey];
        [userDefaults synchronize];
    }
    else {
        self.unitsOfTemperature = [unitOfTemperatureObject integerValue];
    }
    
    // Kilometers or miles
    NSNumber *unitsOfLengthObject = [userDefaults objectForKey:MKSettingsViewControllerUnitsOfLengthKey];
    if (!unitsOfLengthObject) {
        self.unitsOfLength = MKWeatherUnitsOfLengthTypeKilometers;
        
        [userDefaults setObject:@(MKWeatherUnitsOfLengthTypeKilometers) forKey:MKSettingsViewControllerUnitsOfLengthKey];
        [userDefaults synchronize];
    }
    else {
        self.unitsOfLength = [unitsOfLengthObject integerValue];
    }
}

- (void)updateUI {
    self.cityLabel.text = [self.selectedLocation concatenateCityAndCountryStrings];
    self.weatherLabel.text = [self.currentWeather weatherStringInUnitsOfTemperature:self.unitsOfTemperature];
    self.currentLocationImage.hidden = ![self.selectedLocation.isCurrentLocation boolValue];
    self.weatherImage.image = [self.currentWeather weatherImageFromTextualDescription];
    
    self.humidityLabel.text = [self.currentWeather humidityString];
    self.precipitationLabel.text = [self.currentWeather precipitationString];
    self.pressureLabel.text = [self.currentWeather pressureString];
    self.windSpeedLabel.text = [self.currentWeather windSpeedStringInUnitsOfLength:self.unitsOfLength];
    self.windDirectionLabel.text = self.currentWeather.windDirection;
    
    // Adjust horizontal position of city label and location icon in case of current location
    self.cityLabelCenterXConstraint.constant = [self.selectedLocation.isCurrentLocation boolValue] ? -7 : 0;
}

- (void)fetchWeatherDataForLocation:(MKLocation *)location {
    [[MKWeatherAPIClient sharedClient] fetchWeatherDataAtLocation:location withBlock:^(MKLocation *location, NSError *error) {
        self.currentWeather = location.currentWeather;
        
        [self updateUI];
    }];
}

- (void)showActivityIndicator {
    self.containerView.hidden = YES;
    self.activityIndicator.hidden = NO;
    
    [self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator {
    self.containerView.hidden = NO;
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
    self.currentWeather = self.selectedLocation.currentWeather;
    
    [self updateUI];
}

@end
