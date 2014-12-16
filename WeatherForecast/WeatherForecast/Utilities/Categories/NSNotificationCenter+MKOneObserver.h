//
//  NSNotificationCenter+MKOneObserver.h
//  WeatherForecast
//
//  Created by Michal Kalis on 16/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotificationCenter (MKOneObserver)

+ (void)addToDefaultCenterObserver:(id)observer name:(NSString *)name selector:(SEL)selector object:(id)object;

@end
