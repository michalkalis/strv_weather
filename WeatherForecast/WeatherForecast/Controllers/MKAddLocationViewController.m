//
//  MKAddLocationViewController.m
//  WeatherForecast
//
//  Created by Michal Kalis on 18/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKAddLocationViewController.h"

@implementation MKAddLocationViewController

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    self.navigationItem.rightBarButtonItem = searchBarItem;
}

@end
