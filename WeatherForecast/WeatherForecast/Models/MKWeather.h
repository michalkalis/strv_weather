//
//  Weather.h
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MKLocation;

@interface MKWeather : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * humidity;
@property (nonatomic, retain) NSString * precipitation;
@property (nonatomic, retain) NSString * pressure;
@property (nonatomic, retain) NSString * temperatureInCelsius;
@property (nonatomic, retain) NSString * temperatureInFahrenheit;
@property (nonatomic, retain) NSString * textualDescription;
@property (nonatomic, retain) NSString * windDirection;
@property (nonatomic, retain) NSString * windSpeedInKilometers;
@property (nonatomic, retain) NSString * windSpeedInMiles;
@property (nonatomic, retain) MKLocation *forecastLocation;
@property (nonatomic, retain) MKLocation *currentWeatherLocation;

@end
