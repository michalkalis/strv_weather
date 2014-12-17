//
//  MKWeatherBuilder.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKWeatherBuilder.h"
#import "MKCoreDataManager.h"
#import "NSManagedObject+MKCustomInit.h"
#import "NSObject+MKNullObject.h"
#import "MKLocation.h"
#import "MKWeather.h"

#import "NSDate+MKUtils.h"

@implementation MKWeatherBuilder

+ (void)buildWeatherObjectsForLocation:(MKLocation *)location fromJSONObject:(id)JSONObject {
    NSDictionary *data = [NSObject returnObjectOrNil:JSONObject[@"data"]];
    
    if (data) {
        // Firstly remove the previously stored weather objects
        [[MKCoreDataManager sharedManager] deleteAllObjectOfEntity:@"MKWeather"];
        
        // Location name
        NSArray *nearestAreas = [NSObject returnObjectOrNil:data[@"nearest_area"]];
        if (nearestAreas && nearestAreas.count > 0) {
            location.city = [MKWeatherBuilder parseCityFromDictionary:nearestAreas.firstObject];
            location.country = [MKWeatherBuilder parseCountryFromDictionary:nearestAreas.firstObject];
        }
        
        // Current weather
        NSArray *currentConditions = [NSObject returnObjectOrNil:data[@"current_condition"]];
        
        if (currentConditions && currentConditions.count > 0) {
            NSDictionary *currentWeather = currentConditions.firstObject;
            
            if (currentWeather) {
                location.currentWeather = [MKWeatherBuilder createWeatherFromDictionary:currentWeather current:YES];
            }
        }
        
        // Forecasts
        NSArray *forecastWeathers = [NSObject returnObjectOrNil:data[@"weather"]];
        
        if (forecastWeathers && forecastWeathers.count > 0) {
            NSMutableSet *weatherForecasts = [NSMutableSet set];
            
            for (NSDictionary *w in forecastWeathers) {
                MKWeather *weather;
                NSArray *weatherArray = [NSObject returnObjectOrNil:w[@"hourly"]];
                
                if (weatherArray && weatherArray.count > 0) {
                    NSDictionary *weatherDictionary = weatherArray.firstObject;
                    weather = [MKWeatherBuilder createWeatherFromDictionary:weatherDictionary current:NO];
                    
                    weather.date = [NSDate dateFromString:[NSObject returnObjectOrNil:w[@"date"]]];
                    
                    [weatherForecasts addObject:weather];
                }
                
            }
            
            location.forecasts = [weatherForecasts copy];
        }
        
        [[MKCoreDataManager sharedManager] saveContext];
    }
}

+ (NSString *)parseValueFromArrayOfDictionaries:(NSArray *)dictionaries forKey:(NSString *)key {
    if (dictionaries && dictionaries.count > 0) {
        return [NSObject returnObjectOrNil:dictionaries.firstObject[key]];
    }
    
    return nil;
}

+ (NSString *)parseCityFromDictionary:(NSDictionary *)nearestAreaDictionary {
    NSArray *areaNames = [NSObject returnObjectOrNil:nearestAreaDictionary[@"areaName"]];
    
    return [MKWeatherBuilder parseValueFromArrayOfDictionaries:areaNames forKey:@"value"];
}

+ (NSString *)parseCountryFromDictionary:(NSDictionary *)nearestAreaDictionary {
    NSArray *countries = [NSObject returnObjectOrNil:nearestAreaDictionary[@"country"]];
    
    return [MKWeatherBuilder parseValueFromArrayOfDictionaries:countries forKey:@"value"];
}

+ (MKWeather *)createWeatherFromDictionary:(NSDictionary *)weatherDictionary current:(BOOL)current {
    MKWeather *weather = [[MKWeather alloc] initWithContext:[MKCoreDataManager sharedManager].managedObjectContext];
    
    // For today's weather, parse all necessary attributes
    if (current) {
        weather.humidity = [NSObject returnObjectOrNil:weatherDictionary[@"humidity"]];
        weather.precipitation = [NSObject returnObjectOrNil:weatherDictionary[@"precipMM"]];
        weather.pressure = [NSObject returnObjectOrNil:weatherDictionary[@"pressure"]];
        weather.windDirection = [NSObject returnObjectOrNil:weatherDictionary[@"winddir16Point"]];
        weather.windSpeedInKilometers = [NSObject returnObjectOrNil:weatherDictionary[@"windspeedKmph"]];
        weather.windSpeedInMiles = [NSObject returnObjectOrNil:weatherDictionary[@"windspeedMiles"]];
        weather.temperatureInCelsius = [NSObject returnObjectOrNil:weatherDictionary[@"temp_C"]];
        weather.temperatureInFahrenheit = [NSObject returnObjectOrNil:weatherDictionary[@"temp_F"]];
    }
    else {
        weather.temperatureInCelsius = [NSObject returnObjectOrNil:weatherDictionary[@"tempC"]];
        weather.temperatureInFahrenheit = [NSObject returnObjectOrNil:weatherDictionary[@"tempF"]];
    }
    
    
    NSArray *weatherDescriptions = [NSObject returnObjectOrNil:weatherDictionary[@"weatherDesc"]];
    if (weatherDescriptions) {
        NSDictionary *weatherDescription = weatherDescriptions.firstObject;
        
        if (weatherDescription) {
            weather.textualDescription = [NSObject returnObjectOrNil:weatherDescription[@"value"]];
        }
    }
    
    return weather;
}

@end
