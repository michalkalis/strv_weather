//
//  MKTodayViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKTodayViewController.h"
#import "MKTabBarController.h"

#import "MKWeatherAPIClient.h"
#import "MKWeather.h"
#import "MKLocation.h"

static NSString * const MKTodayViewControllerLocalizedComment = @"Today";

@interface MKTodayViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cityLabelCenterXConstraint;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationImage;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *precipitationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windSpeedLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;

@property (nonatomic, strong) MKWeather *currentWeather;

@end

@implementation MKTodayViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // Needs to be set programmatically as it's not working via IB
        UIImage *image = [[UIImage imageNamed:@"Today"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSel = [[UIImage imageNamed:@"Today_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UITabBarItem *todayTabItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Today", @"General") image:image selectedImage:imageSel];
        
        self.tabBarItem = todayTabItem;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Today", MKTodayViewControllerLocalizedComment);
    
    self.cityLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self updateUI];
}

#pragma mark - Auxiliary

- (void)updateUI {
    self.cityLabel.text = [self.selectedLocation concatenateCityAndCountryStrings];
    self.weatherLabel.text = [self.currentWeather weatherStringInUnitsOfTemperature:self.unitsOfTemperature];
    self.currentLocationImage.hidden = ![self.selectedLocation.isCurrentLocation boolValue];
    self.weatherImage.image = [self.currentWeather weatherImageFromTextualDescription];
    
    self.humidityLabel.text = [self.currentWeather humidityString];
    self.precipitationLabel.text = [self.currentWeather precipitationString];
    self.pressureLabel.text = [self.currentWeather pressureString];
    self.windSpeedLabel.text = [self.currentWeather windSpeedStringInUnitsOfLength:self.unitsOfLength];
    self.windDirectionLabel.text = self.currentWeather.windDirection;
    
    // Adjust horizontal position of city label and location icon in case of current location
    self.cityLabelCenterXConstraint.constant = [self.selectedLocation.isCurrentLocation boolValue] ? -7 : 0;
}

- (void)fetchWeatherDataForLocation:(MKLocation *)location {
    [[MKWeatherAPIClient sharedClient] fetchWeatherDataAtLocation:location withBlock:^(MKLocation *location, NSError *error) {
        self.currentWeather = location.currentWeather;
        
        [self updateUI];
    }];
}

- (void)showActivityIndicator {
    self.containerView.hidden = YES;
    self.activityIndicator.hidden = NO;
    
    [self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator {
    self.containerView.hidden = NO;
    self.activityIndicator.hidden = YES;
    
    [self.activityIndicator stopAnimating];
}

#pragma mark - Notifications

- (void)locationStartedUpdating:(NSNotification *)__unused notification {
    [self showActivityIndicator];
}

- (void)updateWeatherData:(NSNotification *)notification {
    [self hideActivityIndicator];
    
    MKLocation *location = notification.object;
    self.selectedLocation = location;
    self.currentWeather = self.selectedLocation.currentWeather;
    
    [self updateUI];
}

@end
