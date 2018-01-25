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

+(NSDictionary*)convertResult:(NSDictionary*)result withCurrentTemperatureFormat:(OWMTemperatureFormat)tempFormat {
    NSMutableDictionary *newDict = [NSMutableDictionary new];
    NSMutableDictionary *newMain = [NSMutableDictionary new];
    
    NSMutableDictionary *main = [[result objectForKey:@"main"] mutableCopy];
    if (main) {
        newMain[@"temp"] = [Utils convertTemperature:main[@"temp"] toFormat:tempFormat];
        newMain[@"temp_min"] = [Utils convertTemperature:main[@"temp_min"] toFormat:tempFormat];
        newMain[@"temp_max"] = [Utils convertTemperature:main[@"temp_max"] toFormat:tempFormat];
        
        newDict[@"main"] = newMain;
    }
    
    return newDict;
}

@end
