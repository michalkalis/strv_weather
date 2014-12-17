//
//  UITableView+MKEmptyCells.m
//  WeatherForecast
//
//  Created by Michal Kalis on 18/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "UITableView+MKEmptyCells.h"

@implementation UITableView (MKEmptyCells)

- (void)hideEmptyCells {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableFooterView = footerView;
}

@end
