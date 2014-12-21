//
//  MKAddLocationViewController.h
//  WeatherForecast
//
//  Created by Michal Kalis on 18/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKAddLocationDelegate.h"

@interface MKAddLocationViewController : UIViewController

@property (nonatomic, weak) id<MKAddLocationDelegate> delegate;

@end
