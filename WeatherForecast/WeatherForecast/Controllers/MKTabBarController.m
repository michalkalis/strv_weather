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

NSString * const MKTabBarControllerDidFetchWeatherDataNotification = @"MKTabBarControllerDidFetchWeatherDataNotification";

NSTimeInterval const MKTabBarControllerMaxTimeInterval = 30.0;

@interface MKTabBarController () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *locationManager;

@end

@implementation MKTabBarController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self handleLocation];
}

#pragma mark - Auxiliary

- (void)fetchWeatherDataForLocation:(MKLocation *)location {
    [[MKWeatherAPIClient sharedClient] fetchWeatherDataAtLocation:location withBlock:^(MKLocation *location, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MKTabBarControllerDidFetchWeatherDataNotification object:location];
    }];
}

#pragma mark - Location

- (void)handleLocation {
    // Location services disabled, skipping location update
    if (![CLLocationManager locationServicesEnabled] || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        [self stopGettingLocation];
    }
    else if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        self.locationManager.delegate = self;
        
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        else {
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
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorized || status == kCLAuthorizationStatusRestricted) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation *location = locations.lastObject;
    
    if (location.horizontalAccuracy < 100.0) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stopGettingLocation) object:nil];
        [self stopGettingLocation];
        
        MKLocation *locationObject = [[MKCoreDataManager sharedManager] updateCurrentLocationObjectWithLocation:location name:nil];
        
        [self fetchWeatherDataForLocation:locationObject];
    }
}

@end
