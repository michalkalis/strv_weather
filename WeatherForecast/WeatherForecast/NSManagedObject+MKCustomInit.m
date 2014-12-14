//
//  NSManagedObject+MKCustomInit.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "NSManagedObject+MKCustomInit.h"

@implementation NSManagedObject (MKCustomInit)

- (instancetype)initWithContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    return [self initWithEntity:entityDescription insertIntoManagedObjectContext:context];
}

@end
