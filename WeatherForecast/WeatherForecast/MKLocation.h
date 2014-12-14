//
//  Location.h
//  WeatherForecast
//
//  Created by Michal Kalis on 13/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MKLocation : NSManagedObject

@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * zip;
@property (nonatomic, retain) NSSet *weathers;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addWeathersObject:(NSManagedObject *)value;
- (void)removeWeathersObject:(NSManagedObject *)value;
- (void)addWeathers:(NSSet *)values;
- (void)removeWeathers:(NSSet *)values;

@end
