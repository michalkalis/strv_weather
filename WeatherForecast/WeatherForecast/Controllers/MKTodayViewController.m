//
//  MKTodayViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKTodayViewController.h"
#import "MKWeatherAPIClient.h"
#import "MKWeather.h"
#import "MKLocation.h"
#import "MKCoreDataManager.h"
#import "NSManagedObject+MKCustomInit.h"

@interface MKTodayViewController ()

@property (nonatomic, strong) MKWeather *currentWeather;

@end

@implementation MKTodayViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKLocation *location = [[MKLocation alloc] initWithContext:[MKCoreDataManager sharedManager].managedObjectContext];
    location.latitude = [@49.19106 stringValue];
    location.longitude = [@16.611419 stringValue];
    location.name = @"Brno";
    
    [[MKWeatherAPIClient sharedClient] fetchWeatherDataAtLocation:location withBlock:^(MKLocation *location, NSError *error) {
        self.currentWeather = location.currentWeather;
        
        [self updateUI];
    }];
}

- (void)updateUI {
    
}

@end
