//
//  City.h
//  WeatherApp
//
//  Created by Никита on 02/11/2018.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface City : NSObject

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;

+(instancetype)cityFromDictionary:(NSDictionary*)cityInfo;
+(instancetype)cityFromManagedObject:(NSManagedObject*)cityManagedObject;

@end
