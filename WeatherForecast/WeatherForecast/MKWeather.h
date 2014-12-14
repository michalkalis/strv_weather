//
//  Weather.h
//  WeatherForecast
//
//  Created by Michal Kalis on 13/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface MKWeather : NSManagedObject

@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSString * textualDescription;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSNumber * precipitation;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSNumber *windSpeed;
@property (nonatomic, retain) NSString * windDirection;
@property (nonatomic, retain) Location *location;

@end
