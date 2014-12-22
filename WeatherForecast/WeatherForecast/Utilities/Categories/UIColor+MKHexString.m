//
//  UIColor+MKHexString.m
//  WeatherForecast
//
//  Created by Michal Kalis on 16/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "UIColor+MKHexString.h"

@implementation UIColor (MKHexString)

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
