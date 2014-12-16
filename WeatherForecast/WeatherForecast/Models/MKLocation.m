//
//  Location.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKLocation.h"
#import "MKWeather.h"

#import "NSString+MKEmptiness.h"


@implementation MKLocation

@dynamic isCurrentLocation;
@dynamic latitude;
@dynamic longitude;
@dynamic city;
@dynamic country;
@dynamic zip;
@dynamic forecasts;
@dynamic currentWeather;

- (NSString *)concatenateCityAndCountryStrings {
    if (![self.city notEmpty] && ![self.country notEmpty]) {
        return @"-";
    }
    else if (![self.city notEmpty]) {
        return self.country;
    }
    else if (![self.country notEmpty]) {
        return self.city;
    }
    
    return [NSString stringWithFormat:@"%@, %@", self.city, self.country];
}

@end
