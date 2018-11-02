//
//  City.m
//  WeatherApp
//
//  Created by Никита on 02/11/2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import "City.h"

@implementation City

+(instancetype)cityFromDictionary:(NSDictionary*)cityInfo {
    City *city = [City new];
    city.identifier = [cityInfo[@"id"] stringValue];
    city.name = cityInfo[@"name"];
    city.country = cityInfo[@"country"];
    city.longitude = cityInfo[@"coord"][@"lon"];
    city.latitude = cityInfo[@"coord"][@"lat"];
    return city;
}

+(instancetype)cityFromManagedObject:(NSManagedObject*)cityManagedObject {
    City *city = [City new];
    city.identifier = [cityManagedObject valueForKey:@"id"];
    city.name = [cityManagedObject valueForKey:@"name"];
    city.country = [cityManagedObject valueForKey:@"country"];
    city.longitude = [cityManagedObject valueForKey:@"lon"];
    city.latitude = [cityManagedObject valueForKey:@"lat"];
    return city;
}

@end
