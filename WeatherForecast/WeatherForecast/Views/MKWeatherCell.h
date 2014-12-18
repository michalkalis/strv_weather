//
//  MKForecastCell.h
//  WeatherForecast
//
//  Created by Michal Kalis on 17/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKWeatherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *currentLocationImage;

@end
