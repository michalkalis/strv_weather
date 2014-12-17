//
//  MKForecastCell.h
//  WeatherForecast
//
//  Created by Michal Kalis on 17/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKForecastCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;

@end
