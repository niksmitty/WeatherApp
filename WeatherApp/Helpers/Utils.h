//
//  Utils.h
//  WeatherApp
//
//  Created by Nikita Votyakov on 24.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    OWMTemperatureKelvin,
    OWMTemperatureCelsius,
    OWMTemperatureFahrenheit
} OWMTemperatureFormat;

@interface Utils : NSObject

+(NSDictionary*)convertResult:(NSDictionary*)result withCurrentTemperatureFormat:(OWMTemperatureFormat)tempFormat;

@end
