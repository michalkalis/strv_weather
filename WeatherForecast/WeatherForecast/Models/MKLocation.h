//
//  Location.h
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MKWeather;

@interface MKLocation : NSManagedObject

@property (nonatomic, retain) NSNumber *isCurrentLocation;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *forecasts;
@property (nonatomic, retain) MKWeather *currentWeather;
@end

@interface MKLocation (CoreDataGeneratedAccessors)

- (void)addForecastsObject:(MKWeather *)value;
- (void)removeForecastsObject:(MKWeather *)value;
- (void)addForecasts:(NSSet *)values;
- (void)removeForecasts:(NSSet *)values;

@end
