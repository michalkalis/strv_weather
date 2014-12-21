//
//  MKSettingsViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKSettingsViewController.h"
#import "MKWeather.h"

NSString * const MKSettingsViewControllerUnitsOfTemperatureKey = @"MKSettingsViewControllerUnitsOfTemperatureKey";
NSString * const MKSettingsViewControllerUnitsOfLengthKey = @"MKSettingsViewControllerUnitsOfLengthKey";

NSString * const MKSettingsViewControllerUnitsOfLengthMeters = @"Meters";
NSString * const MKSettingsViewControllerUnitsOfLengthMiles = @"Miles";
NSString * const MKSettingsViewControllerUnitsOfTemperatureCelsius = @"Celsius";
NSString * const MKSettingsViewControllerUnitsOfTemperatureFahrenheit = @"Fahrenheit";

@interface MKSettingsViewController ()

@property (nonatomic) MKWeatherUnitsOfLengthType lengthType;
@property (nonatomic) MKWeatherUnitsOfTemperatureType temperatureType;

@property (weak, nonatomic) IBOutlet UIButton *unitsOfLengthButton;
@property (weak, nonatomic) IBOutlet UIButton *unitsOfTemperatureButton;

- (IBAction)changeUnitsOfLength:(UIButton *)button;
- (IBAction)changeUnitsOfTemperature:(UIButton *)button;

@end

@implementation MKSettingsViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // Needs to be set programmatically as it's not working via IB
        UIImage *image = [[UIImage imageNamed:@"Settings"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSel = [[UIImage imageNamed:@"Settings_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *settingsTabItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Settings", @"General") image:image selectedImage:imageSel];
        
        self.tabBarItem = settingsTabItem;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", @"Settings");
    
    // Fill properties from stored values in user defaults
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSNumber *unitOfTemperatureObject = [userDefaults objectForKey:MKSettingsViewControllerUnitsOfTemperatureKey];
    NSNumber *unitsOfLengthObject = [userDefaults objectForKey:MKSettingsViewControllerUnitsOfLengthKey];
    
    self.temperatureType = [unitOfTemperatureObject integerValue];
    self.lengthType = [unitsOfLengthObject integerValue];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateUI];
}

#pragma mark - Actions

- (IBAction)changeUnitsOfLength:(UIButton *)button {
    // Swap values
    if (self.lengthType == MKWeatherUnitsOfLengthTypeKilometers) {
        self.lengthType = MKWeatherUnitsOfLengthTypeMiles;
    }
    else if (self.lengthType == MKWeatherUnitsOfLengthTypeMiles) {
        self.lengthType = MKWeatherUnitsOfLengthTypeKilometers;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(self.lengthType) forKey:MKSettingsViewControllerUnitsOfLengthKey];
    [userDefaults synchronize];
    
    [self updateUI];
}

- (IBAction)changeUnitsOfTemperature:(UIButton *)button {
    // Swap values
    if (self.temperatureType == MKWeatherUnitsOfTemperatureTypeCelsius) {
        self.temperatureType = MKWeatherUnitsOfTemperatureTypeFahrenheit;
    }
    else if (self.temperatureType == MKWeatherUnitsOfTemperatureTypeFahrenheit) {
        self.temperatureType = MKWeatherUnitsOfTemperatureTypeCelsius;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@(self.temperatureType) forKey:MKSettingsViewControllerUnitsOfTemperatureKey];
    [userDefaults synchronize];
    
    [self updateUI];
}

#pragma mark - Auxiliary

- (void)updateUI {
    // Kilometers or miles
    NSString *lengthTitle;
    if (self.lengthType == MKWeatherUnitsOfLengthTypeKilometers) {
        lengthTitle = MKSettingsViewControllerUnitsOfLengthMeters;
    }
    else if (self.lengthType == MKWeatherUnitsOfLengthTypeMiles) {
        lengthTitle = MKSettingsViewControllerUnitsOfLengthMiles;
    }
    [self.unitsOfLengthButton setTitle:lengthTitle forState:UIControlStateNormal];
    
    // Celsius or Fahrenheit
    NSString *temperatureTitle;
    if (self.temperatureType == MKWeatherUnitsOfTemperatureTypeCelsius) {
        temperatureTitle = MKSettingsViewControllerUnitsOfTemperatureCelsius;
    }
    else if (self.temperatureType == MKWeatherUnitsOfTemperatureTypeFahrenheit) {
        temperatureTitle = MKSettingsViewControllerUnitsOfTemperatureFahrenheit;
    }
    [self.unitsOfTemperatureButton setTitle:temperatureTitle forState:UIControlStateNormal];
}

@end
