//
//  NSObject+MKNullObject.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "NSObject+MKNullObject.h"

@implementation NSObject (MKNullObject)

+ (id)returnObjectOrNil:(id)object {
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

+ (NSNumber *)returnNumberOrNil:(id)object {
    if ([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return [NSDecimalNumber decimalNumberWithString:object];
}

@end
