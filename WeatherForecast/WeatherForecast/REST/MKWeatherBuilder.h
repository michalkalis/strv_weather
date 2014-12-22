//
//  MKWeatherBuilder.h
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

@import Foundation;
@class MKLocation;

@interface MKWeatherBuilder : NSObject

+ (void)buildWeatherObjectsForLocation:(MKLocation *)location fromJSONObject:(id)JSONObject;

@end
