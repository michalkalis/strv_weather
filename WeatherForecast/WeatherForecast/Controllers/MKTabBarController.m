//
//  MKTabBarController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 16/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKTabBarController.h"
#import "MKWeatherAPIClient.h"
#import "MKCoreDataManager.h"
#import "MKLocation.h"
#import "MKWeather.h"

NSString * const MKTabBarControllerDidStartUpdatingLocationNotification = @"MKTabBarControllerDidStartUpdatingLocationNotification";
NSString * const MKTabBarControllerFailedGettingLocationNotification = @"MKTabBarControllerFailedGettingLocationNotification";
NSString * const MKTabBarControllerDidFetchWeatherDataNotification = @"MKTabBarControllerDidFetchWeatherDataNotification";

NSTimeInterval const MKTabBarControllerMaxTimeInterval = 30.0;

@interface MKTabBarController () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation MKTabBarController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLocation];
}

#pragma mark - Auxiliary

- (void)fetchWeatherDataForLocation:(MKLocation *)location {
    [[MKWeatherAPIClient sharedClient] fetchWeatherDataAtLocation:location withBlock:^(MKLocation *location, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MKTabBarControllerDidFetchWeatherDataNotification object:location];
    }];
}

- (void)postLocationUpdatingStartNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKTabBarControllerDidStartUpdatingLocationNotification object:nil];
}

- (void)postLocationGettingFailedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:MKTabBarControllerFailedGettingLocationNotification object:nil];
}

#pragma mark - Location

- (void)updateLocation {
    // Location services disabled, skipping location update
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self stopGettingLocation];
        [self postLocationGettingFailedNotification];
    }
    else if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        else {
            [self postLocationUpdatingStartNotification];
            [self.locationManager startUpdatingLocation];
        }
        
        [self performSelector:@selector(stopGettingLocation) withObject:nil afterDelay:MKTabBarControllerMaxTimeInterval];
    }
}

- (void)stopGettingLocation {
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil; // Delegate still send one more message although is stopped
}

#pragma mark - Core location delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
#ifdef DEBUG
    NSLog(@"Changed location authorization status: %d", status);
#endif
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusRestricted) {
        [self postLocationUpdatingStartNotification];
        [self.locationManager startUpdatingLocation];
    }
    else {
        [self postLocationGettingFailedNotification];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
#ifdef DEBUG
    NSLog(@"Did update locations");
#endif
    CLLocation *location = locations.lastObject;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopGettingLocation) object:nil];
    [self stopGettingLocation];
    
    MKLocation *locationObject = [[MKCoreDataManager sharedManager] fetchCurrentLocationObject];
    
    locationObject.isCurrentLocation = @YES;
    
    if (location) {
        locationObject.longitude = [@(location.coordinate.longitude) stringValue];
        locationObject.latitude = [@(location.coordinate.latitude) stringValue];
    }
    
    [[MKCoreDataManager sharedManager] saveContext];
    
    [self fetchWeatherDataForLocation:locationObject];
}

@end
