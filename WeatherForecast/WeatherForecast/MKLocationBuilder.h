//
//  MKLocationBuilder.h
//  WeatherForecast
//
//  Created by Michal Kalis on 21/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKLocationBuilder : NSObject

+ (NSArray *)buildLocationObjectsFromJSONObject:(id)JSONObject;

@end
