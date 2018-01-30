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

-(void)getCurrentWeatherByCity:(NSString*)city withCompletionHandler:(void (^)(NSError *error, NSDictionary *result))completion;
-(NSString*)getIconFullUrlWithIconId:(NSString*)iconId;

@end
