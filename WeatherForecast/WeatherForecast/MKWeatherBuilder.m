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

@implementation MKWeatherBuilder

+ (void)buildWeatherObjectsForLocation:(MKLocation *)location fromJSONObject:(id)JSONObject {
    NSDictionary *data = [NSObject returnObjectOrNil:JSONObject[@"data"]];
    
    if (data) {
        // Firstly remove the previously stored weather objects
        [[MKCoreDataManager sharedManager] deleteAllObjectOfEntity:@"MKWeather"];
        
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
                NSArray *weatherArray = [NSObject returnObjectOrNil:w[@"hourly"]];
                
                if (weatherArray && weatherArray.count > 0) {
                    NSDictionary *weatherDictionary = weatherArray.firstObject;
                    [weatherForecasts addObject:[MKWeatherBuilder createWeatherFromDictionary:weatherDictionary current:NO]];
                }
            }
            
            location.forecasts = [weatherForecasts copy];
        }
        
        [[MKCoreDataManager sharedManager] saveContext];
    }
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
    }
    
    weather.temperatureInCelsius = [NSObject returnObjectOrNil:weatherDictionary[@"temp_C"]];
    weather.temperatureInFahrenheit = [NSObject returnObjectOrNil:weatherDictionary[@"temp_F"]];
    
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
