//
//  NSObject+MKNullObject.h
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MKNullObject)

+ (id)returnObjectOrNil:(id)object;
+ (NSNumber *)returnNumberOrNil:(id)object;

@end
