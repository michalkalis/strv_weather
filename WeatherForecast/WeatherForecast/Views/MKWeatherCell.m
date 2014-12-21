//
//  MKForecastCell.m
//  WeatherForecast
//
//  Created by Michal Kalis on 17/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKWeatherCell.h"
#import "MKLocation.h"
#import "MKWeather.h"
#import "MKWeatherAPIClient.h"

@implementation MKWeatherCell

- (void)setLocation:(MKLocation *)location {
    _location = location;
    
    MKWeather *weather = location.currentWeather;
    
    self.weatherIcon.image = [weather weatherImageFromTextualDescription];
    self.titleLabel.text = location.city;
    self.weatherTextLabel.text = weather.textualDescription;
    self.temperatureLabel.text = [weather temperatureWithDegreesInUnitsOfTemperature:self.unitsOfTemperature];
    self.currentLocationImage.hidden = ![location.isCurrentLocation boolValue];
    
    __weak __typeof__(self) weakSelf = self;
    if (!location.forecasts || location.forecasts.count == 0) {
        [[MKWeatherAPIClient sharedClient] fetchWeatherDataAtLocation:location withBlock:^(MKLocation *fetchedLocation, NSError *error) {
            if (fetchedLocation) {
                weakSelf.weatherIcon.image = [fetchedLocation.currentWeather weatherImageFromTextualDescription];
                weakSelf.titleLabel.text = fetchedLocation.city;
                weakSelf.weatherTextLabel.text = fetchedLocation.currentWeather.textualDescription;
                weakSelf.temperatureLabel.text = [fetchedLocation.currentWeather temperatureWithDegreesInUnitsOfTemperature:self.unitsOfTemperature];
            }
        }];
    }
}

@end
