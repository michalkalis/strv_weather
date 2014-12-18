//
//  MKLocationViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 18/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKLocationViewController.h"
#import "MKSettingsViewController.h"
#import "MKWeatherCell.h"
#import "MKCoreDataManager.h"
#import "MKLocation.h"
#import "MKWeather.h"

#import "UITableView+MKEmptyCells.h"

static NSString * const MKWeatherCellIdentifier = @"MKWeatherCellIdentifier";

@interface MKLocationViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *locations;
@property (nonatomic) MKWeatherUnitsOfTemperatureType unitsOfTemperature;

- (IBAction)dismiss:(id)sender;
- (IBAction)addLocation:(id)sender;

@end

@implementation MKLocationViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locations = [self fetchLocations];
    
    [self updateUnitsOfTemperature];
    
    self.title = NSLocalizedString(@"Location", @"Location");
    
    [self stylize];
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)addLocation:(id)sender {
}

#pragma mark - Auxiliary

- (void)stylize {
    [self.tableView hideEmptyCells];
}

- (void)updateUnitsOfTemperature {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    // Celsius or Fahrenheit
    NSNumber *unitOfTemperatureObject = [userDefaults objectForKey:MKSettingsViewControllerUnitsOfTemperatureKey];
    if (!unitOfTemperatureObject) {
        self.unitsOfTemperature = MKWeatherUnitsOfTemperatureTypeCelsius;
    }
    else {
        self.unitsOfTemperature = [unitOfTemperatureObject integerValue];
    }
}

- (NSArray *)fetchLocations {
    NSManagedObjectContext *context = [MKCoreDataManager sharedManager].managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:NSStringFromClass([MKLocation class]) inManagedObjectContext:context]];
    
    return [context executeFetchRequest:fetchRequest error:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKWeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:MKWeatherCellIdentifier];
    
    MKLocation *location = self.locations[indexPath.row];
    MKWeather *weather = location.currentWeather;
    
    cell.weatherIcon.image = [weather weatherImageFromTextualDescription];
    cell.titleLabel.text = location.city;
    cell.weatherTextLabel.text = weather.textualDescription;
    cell.temperatureLabel.text = [weather temperatureWithDegreesInUnitsOfTemperature:self.unitsOfTemperature];
    
    return cell;
}

@end
