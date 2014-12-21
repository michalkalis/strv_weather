//
//  MKHTTPSessionManager.h
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@class MKLocation;

@import MapKit;

UIKIT_EXTERN NSString * const MKWeatherAPIClientKey;

@interface MKWeatherAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

- (NSURLSessionDataTask *)fetchWeatherDataAtLocation:(MKLocation *)location withBlock:(void (^)(MKLocation *location, NSError *error))block;
- (NSURLSessionDataTask *)searchLocationsWithText:(NSString *)text withBlock:(void (^)(NSArray *locations, NSError *error))block;

@end
