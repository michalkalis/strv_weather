//
//  Weather.m
//  WeatherForecast
//
//  Created by Michal Kalis on 14/12/14.
//  Copyright (c) 2014 strv. All rights reserved.
//

#import "MKWeather.h"
#import "MKLocation.h"


@implementation MKWeather

@dynamic date;
@dynamic humidity;
@dynamic precipitation;
@dynamic pressure;
@dynamic temperatureInCelsius;
@dynamic temperatureInFahrenheit;
@dynamic textualDescription;
@dynamic windDirection;
@dynamic windSpeedInKilometers;
@dynamic windSpeedInMiles;
@dynamic forecastLocation;
@dynamic currentWeatherLocation;

- (NSString *)temperatureWithDegreesInUnitsOfTemperature:(MKWeatherUnitsOfTemperatureType)temperatureType {
    if (temperatureType == MKWeatherUnitsOfTemperatureTypeCelsius) {
        return [NSString stringWithFormat:@"%@°", self.temperatureInCelsius];
    }
    else if (temperatureType == MKWeatherUnitsOfTemperatureTypeFahrenheit) {
        return [NSString stringWithFormat:@"%@°", self.temperatureInFahrenheit];
    }
    
    return nil;
}

- (NSString *)weatherStringInUnitsOfTemperature:(MKWeatherUnitsOfTemperatureType)temperatureType {
    if (temperatureType == MKWeatherUnitsOfTemperatureTypeCelsius) {
        return [NSString stringWithFormat:@"%@℃ | %@", self.temperatureInCelsius, self.textualDescription];
    }
    else if (temperatureType == MKWeatherUnitsOfTemperatureTypeFahrenheit) {
        return [NSString stringWithFormat:@"%@℉ | %@", self.temperatureInFahrenheit, self.textualDescription];
    }
    
    return nil;
}

- (UIImage *)weatherImageFromTextualDescription {
    UIImage *resultImage = [UIImage imageNamed:@"Sun_Big"];
    
    if ([self.textualDescription caseInsensitiveCompare:@"cloudy"] == NSOrderedSame) {
        return resultImage = [UIImage imageNamed:@"Cloudy_Big"];
    }
    else if ([self.textualDescription caseInsensitiveCompare:@"sunny"] == NSOrderedSame) {
        return resultImage;
    }
    else if ([self.textualDescription caseInsensitiveCompare:@"lightning"] == NSOrderedSame) {
        return resultImage = [UIImage imageNamed:@"Lightning_Big"];
    }
    else if ([self.textualDescription caseInsensitiveCompare:@"windy"] == NSOrderedSame) {
        return resultImage = [UIImage imageNamed:@"WInd_Big"];
    }
    
    return resultImage;
}

- (NSString *)windSpeedStringInUnitsOfLength:(MKWeatherUnitsOfLengthType)lengthType {
    if (lengthType == MKWeatherUnitsOfLengthTypeKilometers) {
        return [NSString stringWithFormat:@"%@ km/h", self.windSpeedInKilometers];
    }
    else if (lengthType == MKWeatherUnitsOfLengthTypeMiles) {
        return [NSString stringWithFormat:@"%@ mph", self.windSpeedInMiles];
    }
    
    return nil;
}

- (NSString *)humidityString {
    return [NSString stringWithFormat:@"%@%%", self.humidity];
}

- (NSString *)precipitationString {
    return [NSString stringWithFormat:@"%@ mm", self.precipitation];
}

- (NSString *)pressureString {
    return [NSString stringWithFormat:@"%@ hPa", self.pressure];
}

@end
