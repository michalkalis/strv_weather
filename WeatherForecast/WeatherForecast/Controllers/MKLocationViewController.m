//
//  MKLocationViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 18/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKLocationViewController.h"
#import "MKSettingsViewController.h"
#import "MKAddLocationViewController.h"
#import "MKWeatherCell.h"
#import "MKCoreDataManager.h"
#import "MKLocation.h"
#import "MKWeather.h"
#import "MKAddLocationDelegate.h"

#import "UITableView+MKEmptyCells.h"

static NSString * const MKWeatherCellIdentifier = @"MKWeatherCellIdentifier";

@interface MKLocationViewController () <UITableViewDataSource, UITableViewDelegate, MKAddLocationDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *locations;
@property (nonatomic) MKWeatherUnitsOfTemperatureType unitsOfTemperature;

- (IBAction)dismiss:(id)sender;

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *navigationController = segue.destinationViewController;
    
    MKAddLocationViewController *viewController = (MKAddLocationViewController *)navigationController.topViewController;
    viewController.delegate = self;
}

#pragma mark - Actions

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Auxiliary

- (void)setLocationObjectSelected:(MKLocation *)location {
    for (MKLocation *l in self.locations) {
        l.isSelected = @NO;
    }
    location.isSelected = @YES;
    [[MKCoreDataManager sharedManager] saveContext];
}

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

#pragma mark - Add location delegate

- (void)didAddLocation {
    self.locations = [self fetchLocations];
    
    [self.tableView reloadData];
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
    
    cell.unitsOfTemperature = self.unitsOfTemperature;
    cell.location = location;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Notify today and forecast view controllers to refresh UI
    MKLocation *location = self.locations[indexPath.row];
    [self setLocationObjectSelected:location];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
