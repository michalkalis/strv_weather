//
//  MKViewController.h
//  WeatherForecast
//
//  Created by Michal Kalis on 17/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKSettingsViewController.h"
#import "MKWeather.h"
#import "MKLocation.h"

@interface MKViewController : UIViewController

@property (nonatomic) MKWeatherUnitsOfTemperatureType unitsOfTemperature;
@property (nonatomic) MKWeatherUnitsOfLengthType unitsOfLength;

@property (nonatomic, strong) MKLocation *selectedLocation;

- (void)locationStartedUpdating:(NSNotification *)__unused notification;
- (void)updateWeatherData:(NSNotification *)notification;

@end
