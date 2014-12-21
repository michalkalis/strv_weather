//
//  CoreDataManager.h
//  WeatherForecast
//
//  Created by Michal Kalis on 13/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreData;
@import CoreLocation;

@class MKLocation;

@interface MKCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (MKCoreDataManager *)sharedManager;

- (void)saveContext;
- (MKLocation *)fetchCurrentLocationObject;
- (MKLocation *)fetchSelectedLocationObject;
- (NSArray *)fetchAllStoredLocations;
- (BOOL)deleteAllWeatherObjectsForLocation:(MKLocation *)location;

@end
