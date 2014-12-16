//
//  NSString+MKEmptiness.m
//  WeatherForecast
//
//  Created by Michal Kalis on 16/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "NSString+MKEmptiness.h"

@implementation NSString (MKEmptiness)

- (BOOL)notEmpty {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length != 0;
}

@end
