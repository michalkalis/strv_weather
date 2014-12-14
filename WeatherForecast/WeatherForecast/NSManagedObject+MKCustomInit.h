//
//  NSManagedObject+MKCustomInit.h
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MKCustomInit)

- (instancetype)initWithContext:(NSManagedObjectContext *)context;

@end
