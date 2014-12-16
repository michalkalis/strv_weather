//
//  MKHTTPSessionManager.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKWeatherAPIClient.h"
#import "MKWeatherBuilder.h"
#import "MKLocation.h"

NSString * const MKWeatherAPIClientKey = @"5de42d10aac5bdb1a1b3b1c8c34f2";
NSString * const MKHTTPSessionManagerURLString = @"https://api.worldweatheronline.com/free/v2/";

@implementation MKWeatherAPIClient

+ (instancetype)sharedClient {
    static MKWeatherAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[MKWeatherAPIClient alloc] initWithBaseURL:[NSURL URLWithString:MKHTTPSessionManagerURLString]];
    });
    
    return _sharedClient;
}

- (NSURLSessionDataTask *)fetchWeatherDataAtLocation:(MKLocation *)location withBlock:(void (^)(MKLocation *location, NSError *error))block {
    MKWeatherAPIClient *client = [MKWeatherAPIClient sharedClient];
    client.responseSerializer = [AFJSONResponseSerializer serializer];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"q"] = [NSString stringWithFormat:@"%@,%@", location.latitude, location.longitude];
    parameters[@"format"] = @"json";
    parameters[@"includelocation"] = @"yes";
    parameters[@"num_of_days"] = @5;
    parameters[@"tp"] = @24;
    parameters[@"key"] = MKWeatherAPIClientKey;
    
    NSURLSessionDataTask *task = [client GET:@"weather.ashx" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        [MKWeatherBuilder buildWeatherObjectsForLocation:location fromJSONObject:responseObject];
        if (block) {
            block(location, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
    
    return task;
}

@end
