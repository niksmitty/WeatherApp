//
//  ViewController.m
//  WeatherApp
//
//  Created by Nikita Votyakov on 23.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import "ViewController.h"
#import "LocationInfo.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *apiKey = @"81d2bde991f9d4ee935b9cc996d94b9c";
    OWMAPIManager = [[OpenWeatherMapAPIManager alloc] initWithApiKey:apiKey];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];
}

-(void)getInfoOfLocation:(CLLocation*)location completion:(void (^)(LocationInfo*))completionHandler {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            if (placemarks && placemarks.count > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                //NSString *address = [NSString stringWithFormat:@"%@ %@,%@ %@", [placemark subThoroughfare], [placemark thoroughfare], [placemark locality], [placemark administrativeArea]];
                LocationInfo *locationInfo = [LocationInfo new];
                locationInfo.subThoroughfare = [placemark subThoroughfare];
                locationInfo.thoroughfare = [placemark thoroughfare];
                locationInfo.locality = [placemark locality];
                locationInfo.administrativeArea = [placemark administrativeArea];
                if (completionHandler)
                    completionHandler(locationInfo);
            }
        } else {
            NSLog(@"Geocode failed with error: %@", error);
            completionHandler(nil);
        }
    }];
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
    CLLocation *newLocation = [locations lastObject];
    NSLog(@"NewLocation %f %f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [self getInfoOfLocation:newLocation completion:^(LocationInfo *locationInfo) {
        [OWMAPIManager getCurrentWeatherByCityname:locationInfo.locality withCompletionHandler:^(NSError *error, NSDictionary *result) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                NSLog(@"%@", result);
            }
        }];
    }];
}

@end
