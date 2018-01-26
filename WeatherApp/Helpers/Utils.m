//
//  Utils.m
//  WeatherApp
//
//  Created by Nikita Votyakov on 24.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(NSNumber*)convertTemperatureFromKelvinToCelsius:(NSNumber*)tempInKelvin {
    return @([tempInKelvin floatValue] - 273.15);
}

+(NSNumber*)convertTemperatureFromKelvinToFahrenheit:(NSNumber*)tempInKelvin {
    return @([tempInKelvin floatValue] * 9/5 - 273.15);
}

+(NSNumber*)convertTemperature:(NSNumber*)tempInKelvin toFormat:(OWMTemperatureFormat)tempFormat {
    switch (tempFormat) {
        case OWMTemperatureCelsius:
            return [Utils convertTemperatureFromKelvinToCelsius:tempInKelvin];
            break;
        case OWMTemperatureFahrenheit:
            return [Utils convertTemperatureFromKelvinToFahrenheit:tempInKelvin];
            break;
        default:
            return tempInKelvin;
            break;
    }
}

+(NSString*)convertUnixTimestampToDateString:(NSNumber*)unixTime {
    NSTimeInterval timeInterval = [unixTime doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateFormat:@"dd.MM.yyyy H:m"];
    
    return [formatter stringFromDate:date];
}

+(NSDictionary*)convertResult:(NSDictionary*)result withCurrentTemperatureFormat:(OWMTemperatureFormat)tempFormat {
    NSMutableDictionary *newDict = [NSMutableDictionary new];
    NSMutableDictionary *newMain = [NSMutableDictionary new];
    NSMutableDictionary *newSys = [NSMutableDictionary new];
    NSMutableArray *newWeather = [NSMutableArray new];
    
    NSArray *weather = [result[@"weather"] mutableCopy];
    if (weather) {
        [newWeather addObjectsFromArray:weather];
        
        newDict[@"weather"] = newWeather;
    }
    
    NSMutableDictionary *main = [result[@"main"] mutableCopy];
    if (main) {
        newMain[@"temp"] = [Utils convertTemperature:main[@"temp"] toFormat:tempFormat];
        newMain[@"temp_min"] = [Utils convertTemperature:main[@"temp_min"] toFormat:tempFormat];
        newMain[@"temp_max"] = [Utils convertTemperature:main[@"temp_max"] toFormat:tempFormat];
        
        newDict[@"main"] = newMain;
    }
    
    NSMutableDictionary *sys = [result[@"sys"] mutableCopy];
    if (sys) {
        newSys[@"country"] = sys[@"country"];
        newSys[@"sunrise"] = [Utils convertUnixTimestampToDateString:sys[@"sunrise"]];
        newSys[@"sunset"] = [Utils convertUnixTimestampToDateString:sys[@"sunset"]];
        
        newDict[@"sys"] = newSys;
    }
    
    NSString *cityName = [result[@"name"] mutableCopy];
    if (cityName) {
        newDict[@"name"] = cityName;
    }
    
    return newDict;
}

@end
