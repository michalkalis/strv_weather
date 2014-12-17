//
//  NSDate+MKUtils.m
//  WeatherForecast
//
//  Created by Michal Kalis on 17/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "NSDate+MKUtils.h"

@implementation NSDate (MKUtils)

+ (NSDate *)dateFromString:(NSString *)dateString {
    static NSDateFormatter *dateFormatter;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    
    return [dateFormatter dateFromString:dateString];
}

- (NSString *)weekDayDescription {
    static NSDateFormatter *dateFormatter;
    
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
    }
    
    return [dateFormatter stringFromDate:self];
}

@end
