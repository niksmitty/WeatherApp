//
//  OpenWeatherMapAPIManager.h
//  WeatherApp
//
//  Created by Nikita Votyakov on 24.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface OpenWeatherMapAPIManager : AFHTTPSessionManager

-(instancetype)initWithApiKey:(NSString*)apiKey;

-(void)getCurrentWeatherByCity:(NSString*)city andTimeZone:(NSTimeZone*)timeZone withCompletionHandler:(void (^)(NSError *error, NSDictionary *result))completion;
-(void)getCurrentWeatherByCityId:(NSString*)cityId andTimeZone:(NSTimeZone*)timeZone withCompletionHandler:(void (^)(NSError *error, NSDictionary *result))completion;
-(NSString*)getIconFullUrlWithIconId:(NSString*)iconId;

@end
