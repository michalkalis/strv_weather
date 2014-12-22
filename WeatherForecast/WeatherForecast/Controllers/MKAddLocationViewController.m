//
//  MKAddLocationViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 18/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKAddLocationViewController.h"
#import "MKWeatherAPIClient.h"
#import "MKLocation.h"
#import "MKCoreDataManager.h"

#import "UIColor+MKHexString.h"

static NSString * const MKAddLocationViewControllerCellIdentifier = @"MKAddLocationViewControllerCellIdentifier";

@interface MKAddLocationViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSURLSessionDataTask *searchTask;
@property (nonatomic, strong) NSArray *foundLocations;

@end

@implementation MKAddLocationViewController

- (void)setFoundLocations:(NSArray *)foundLocations {
    if (!foundLocations || foundLocations.count == 0) {
        [self deleteFoundLocationsExceptLocation:nil];
    }
    
    _foundLocations = foundLocations;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add close nav bar button
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"Location") style:UIBarButtonItemStyleDone target:self action:@selector(dismiss)]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}

- (void)dismiss {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Auxiliary

- (void)stylize {
    self.searchBar.tintColor = [UIColor colorWithHexString:@"#2f91ff"];
    self.searchBar.barTintColor = [UIColor colorWithHexString:@"#2f91ff"];
}

- (void)deleteFoundLocationsExceptLocation:(MKLocation *)location {
    for (MKLocation *l in self.foundLocations) {
        if (!location || l != location) {
            [[MKCoreDataManager sharedManager].managedObjectContext deleteObject:l];
        }
    }
}

- (void)showActivityIndicator {
    self.activityIndicator.hidden = NO;
    self.tableView.hidden = YES;
    [self.activityIndicator startAnimating];
}

- (void)hideActivityIndicator {
    self.activityIndicator.hidden = YES;
    self.tableView.hidden = NO;
    [self.activityIndicator stopAnimating];
}

#pragma mark - Search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
#ifdef DEBUG
    NSLog(@"search text: %@", searchText);
#endif
    
    self.searchText = searchText;
    [self.searchTask cancel];
    
    if (searchText.length == 0) {
        self.foundLocations = @[];
        [self.tableView reloadData];
        return;
    }
    
    for (MKLocation *l in self.foundLocations) {
        [[MKCoreDataManager sharedManager].managedObjectContext deleteObject:l];
    }
    
    [self showActivityIndicator];
    self.searchTask = [[MKWeatherAPIClient sharedClient] searchLocationsWithText:searchText withBlock:^(NSArray *locations, NSError *error) {
#ifdef DEBUG
        NSLog(@"locations count: %lu", (unsigned long)locations.count);
#endif
        // Activity indicator is not hidden when the task has been cancelled, as a new search (task) is ongoing
        if (error && error.code != NSURLErrorCancelled) {
            [self hideActivityIndicator];
        }
        
        if (locations && locations.count > 0) {
            [self hideActivityIndicator];
            self.foundLocations = locations;
            
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.foundLocations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MKAddLocationViewControllerCellIdentifier];
    
    MKLocation *location = self.foundLocations[indexPath.row];
    
    NSString *locationString = [NSString stringWithFormat:@"%@, %@", location.city, location.country];
    
    UIFont *semiboldFont = [UIFont fontWithName:@"ProximaNova-Semibold" size:16];
    UIFont *lightFont = [UIFont fontWithName:@"ProximaNova-Light" size:16];
    UIColor *foregroundColor = [UIColor colorWithHexString:@"333333"];
    
    // Create the attributes
    NSDictionary *semiboldAttributes = @{NSFontAttributeName: semiboldFont, NSForegroundColorAttributeName: foregroundColor};
    NSDictionary *lightAttributes = @{NSFontAttributeName: lightFont};
    const NSRange range = NSMakeRange(0, self.searchText.length);
    
    // Create the attributed string
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:locationString attributes:lightAttributes];
    [attributedText setAttributes:semiboldAttributes range:range];
    
    [cell.textLabel setAttributedText:attributedText];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self deleteFoundLocationsExceptLocation:self.foundLocations[indexPath.row]];
    [[MKCoreDataManager sharedManager] saveContext];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
    
    // Notify location view controller to reload table view data
    if ([self.delegate respondsToSelector:@selector(didAddLocation)]) {
        [self.delegate didAddLocation];
    }
}

@end
