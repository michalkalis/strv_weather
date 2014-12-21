//
//  MKLocationBuilder.m
//  WeatherForecast
//
//  Created by Michal Kalis on 21/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKLocationBuilder.h"
#import "MKCoreDataManager.h"
#import "MKLocation.h"

#import "NSObject+MKNullObject.h"
#import "NSManagedObject+MKCustomInit.h"

@implementation MKLocationBuilder

+ (NSArray *)buildLocationObjectsFromJSONObject:(id)JSONObject {
    NSDictionary *data = [NSObject returnObjectOrNil:JSONObject[@"search_api"]];
    
    NSMutableArray *resultsLocations = [NSMutableArray array];
    NSArray *locationsArray = [NSObject returnObjectOrNil:data[@"result"]];
    
    for (NSDictionary *r in locationsArray) {
        MKLocation *location = [[MKLocation alloc] initWithContext:[MKCoreDataManager sharedManager].managedObjectContext];
        
        location.city = [MKLocationBuilder valueFromArray:[NSObject returnObjectOrNil:r[@"areaName"]]];
        location.country = [MKLocationBuilder valueFromArray:[NSObject returnObjectOrNil:r[@"country"]]];
        location.latitude = [NSObject returnObjectOrNil:r[@"latitude"]];
        location.longitude = [NSObject returnObjectOrNil:r[@"longitude"]];
        location.weatherURLString = [MKLocationBuilder valueFromArray:[NSObject returnObjectOrNil:r[@"weatherUrl"]]];
        
        [resultsLocations addObject:location];
    }
    
    return [resultsLocations copy];
}

+ (NSString *)valueFromArray:(NSArray *)objects {
    if (objects.count > 0) {
        NSDictionary *valueDict = objects.firstObject;
        
        return [NSObject returnObjectOrNil:valueDict[@"value"]];
    }
    
    return nil;
}

@end
