//
//  NSNotificationCenter+MKOneObserver.m
//  WeatherForecast
//
//  Created by Michal Kalis on 16/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "NSNotificationCenter+MKOneObserver.h"

@implementation NSNotificationCenter (MKOneObserver)

+ (void)addToDefaultCenterObserver:(id)observer name:(NSString *)name selector:(SEL)selector object:(id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:observer name:name object:object];
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
}

@end
