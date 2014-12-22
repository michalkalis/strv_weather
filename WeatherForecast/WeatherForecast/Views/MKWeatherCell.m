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

#import "UIColor+MKHexString.h"

@implementation MKWeatherCell

- (void)awakeFromNib {
    self.activityIndicator.color = [UIColor colorWithHexString:@"#2f91ff"];
    self.activityIndicator.hidden = YES;
}

- (void)setLocation:(MKLocation *)location {
    _location = location;
    
    MKWeather *weather = location.currentWeather;
    
    self.weatherIcon.image = [weather weatherImageFromTextualDescription];
    self.titleLabel.text = location.city;
    self.weatherTextLabel.text = weather.textualDescription;
    self.temperatureLabel.text = [weather temperatureWithDegreesInUnitsOfTemperature:self.unitsOfTemperature];
    self.currentLocationImage.hidden = ![location.isCurrentLocation boolValue];
    
    if (self.shouldReloadData) {
        [self showActivityIndicator];
        
        __weak __typeof__(self) weakSelf = self;
        [[MKWeatherAPIClient sharedClient] fetchWeatherDataAtLocation:self.location withBlock:^(MKLocation *fetchedLocation, NSError *error) {
            [weakSelf hideActivityIndicator];
            
            if (fetchedLocation) {
                weakSelf.weatherIcon.image = [fetchedLocation.currentWeather weatherImageFromTextualDescription];
                weakSelf.weatherTextLabel.text = fetchedLocation.currentWeather.textualDescription;
                weakSelf.temperatureLabel.text = [fetchedLocation.currentWeather temperatureWithDegreesInUnitsOfTemperature:self.unitsOfTemperature];
            }
        }];
    }
}

- (void)showActivityIndicator {
    self.activityIndicator.hidden = NO;
    self.temperatureLabel.hidden = YES;
    
    [self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator {
    self.activityIndicator.hidden = YES;
    self.temperatureLabel.hidden = NO;
        
    [self.activityIndicator stopAnimating];
}

@end
