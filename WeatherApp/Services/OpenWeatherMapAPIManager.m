//
//  OpenWeatherMapAPIManager.m
//  WeatherApp
//
//  Created by Nikita Votyakov on 24.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import "OpenWeatherMapAPIManager.h"
#import "Utils.h"

static NSString * const OWMAPIBaseURLString = @"http://api.openweathermap.org/";
static NSString * const OWMAPIDataSuffix = @"data/";
static NSString * const OWMAPIVersion = @"2.5";

@implementation OpenWeatherMapAPIManager {
    NSString *_apiKey;
    OWMTemperatureFormat _currentTempFormat;
}

-(instancetype)initWithApiKey:(NSString*)apiKey {
    self = [super init];
    
    if (self) {
        self = [[OpenWeatherMapAPIManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", OWMAPIBaseURLString]]];
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        _apiKey = apiKey;
        _currentTempFormat = OWMTemperatureCelsius;
    }
    
    return self;
}

-(void)getCurrentWeatherByCity:(NSString*)city withCompletionHandler:(void (^)(NSError *error, NSDictionary *result))completion {
    NSString *urlPart = [NSString stringWithFormat:@"%@%@/weather?q=%@", OWMAPIDataSuffix, OWMAPIVersion, city];
    NSString *fullUrlString = [NSString stringWithFormat:@"%@&APPID=%@", urlPart, _apiKey];
    NSString *escapedUrlString = [fullUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [self GET:escapedUrlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *convertedResult = [Utils convertResult:(NSDictionary*)responseObject withCurrentTemperatureFormat:self->_currentTempFormat];
        if (completion)
            completion(nil, convertedResult);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion)
            completion(error, [NSDictionary dictionary]);
    }];
}

-(void)getCurrentWeatherByCityId:(NSString*)cityId withCompletionHandler:(void (^)(NSError *error, NSDictionary *result))completion {
    NSString *urlPart = [NSString stringWithFormat:@"%@%@/weather?id=%@", OWMAPIDataSuffix, OWMAPIVersion, cityId];
    NSString *fullUrlString = [NSString stringWithFormat:@"%@&APPID=%@", urlPart, _apiKey];
    NSString *escapedUrlString = [fullUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [self GET:escapedUrlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *convertedResult = [Utils convertResult:(NSDictionary*)responseObject withCurrentTemperatureFormat:self->_currentTempFormat];
        if (completion)
            completion(nil, convertedResult);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion)
            completion(error, [NSDictionary dictionary]);
    }];
}

-(NSString*)getIconFullUrlWithIconId:(NSString*)iconId {
    NSString *fullUrlString = [NSString stringWithFormat:@"%@img/w/%@.png", OWMAPIBaseURLString, iconId];
    NSString *escapedUrlString = [fullUrlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    return escapedUrlString;
}

@end
