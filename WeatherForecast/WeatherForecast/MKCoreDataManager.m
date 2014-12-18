//
//  CoreDataManager.m
//  WeatherForecast
//
//  Created by Michal Kalis on 13/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKCoreDataManager.h"
#import "MKLocation.h"
#import "NSManagedObject+MKCustomInit.h"

@implementation MKCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+ (MKCoreDataManager *)sharedManager {
    static MKCoreDataManager *inst;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inst = [[MKCoreDataManager alloc] init];
    });
    return inst;
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
#warning TODO handle Core Data error
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
}

- (MKLocation *)fetchCurrentLocationObject {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *currentLocationRequest = [[NSFetchRequest alloc] init];
    [currentLocationRequest setEntity:[NSEntityDescription entityForName:@"MKLocation" inManagedObjectContext:context]];
    currentLocationRequest.predicate = [NSPredicate predicateWithFormat:@"isCurrentLocation == %@", @YES];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:currentLocationRequest error:&error];
    
    if (error) {
        return nil;
    }
    
    MKLocation *locationObject;
    if (objects.count == 0) {
        locationObject = [[MKLocation alloc] initWithContext:[MKCoreDataManager sharedManager].managedObjectContext];
    }
    else {
        locationObject = objects.firstObject;
    }
    
    return locationObject;
}

- (BOOL)deleteAllObjectOfEntity:(NSString *)entity {
    NSManagedObjectContext *context = self.managedObjectContext;
    NSFetchRequest *allObjects = [[NSFetchRequest alloc] init];
    [allObjects setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
    [allObjects setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:allObjects error:&error];
    
    if (error != nil) {
        return NO;
    }
    
    for (NSManagedObject *o in objects) {
        [context deleteObject:o];
    }
    
    [[MKCoreDataManager sharedManager] saveContext];
    
    return YES;
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreDataModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"WeatherForecast.sqlite"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:[storeURL path]]) {
        NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"WeatherForecast" withExtension:@"sqlite"];
        if (defaultStoreURL) {
            [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
        }
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSError *error;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
