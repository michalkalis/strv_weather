//
//  NSDate+MKUtils.h
//  WeatherForecast
//
//  Created by Michal Kalis on 17/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (MKUtils)

+ (NSDate *)dateFromString:(NSString *)dateString;
- (NSString *)weekDayDescription;

@end
