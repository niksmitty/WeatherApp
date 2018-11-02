//
//  LocationInfo.h
//  WeatherApp
//
//  Created by Nikita Votyakov on 24.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationInfo : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *region;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *ocean;
@property (nonatomic, strong) NSString *postalCode;
@property (nonatomic, strong) NSString *subLocality;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *thoroughfare;
@property (nonatomic, strong) NSString *subThoroughfare;
@property (nonatomic, strong) NSString *administrativeArea;
@property (nonatomic, strong) NSTimeZone *timeZone;

@end
