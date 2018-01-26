//
//  ViewController.m
//  WeatherApp
//
//  Created by Nikita Votyakov on 23.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import "ViewController.h"
#import "LocationInfo.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface ViewController ()

@end

static int const ICON_WIDTH = 50;
static int const OFFSET_WIDTH = 10;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:254./255. green:254./255. blue:254./255. alpha:1.];
    
    [self.activity startAnimating];
    
    self.temperatureValueLabel.text = @"";
    self.currentCityLabel.text = @"";
    self.sunriseTimeLabel.text = @"";
    self.sunsetTimeLabel.text = @"";
    
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

-(float)calculateXCoordForIconWithIndex:(int)index andIconsTotal:(int)count {
    return (self.weatherIconsView.frame.size.width - ICON_WIDTH * count - OFFSET_WIDTH * (count - 1)) / 2 + (ICON_WIDTH + OFFSET_WIDTH) * index;
}

-(void)createIconViewWithIconURL:(NSString*)iconUrlString description:(NSString*)description iconsTotal:(int)iconsCount andCurrentIconIndex:(int)index {
    NSURL *iconUrl = [NSURL URLWithString:iconUrlString];
    if (iconUrl) {
        float x = [self calculateXCoordForIconWithIndex:index andIconsTotal:iconsCount];
        
        UIView *iconView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 50, 71)];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        [iconImageView setImageWithURL:iconUrl];
        [iconView addSubview:iconImageView];
        
        UILabel *iconLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, 50, 21)];
        iconLabel.text = description;
        iconLabel.textAlignment = NSTextAlignmentCenter;
        iconLabel.textColor = [UIColor blackColor];
        iconLabel.font = [UIFont fontWithName:@"American Typewriter" size:12];
        iconLabel.adjustsFontSizeToFitWidth = YES;
        [iconView addSubview:iconLabel];
        
        [self.weatherIconsView addSubview:iconView];
    }
}

-(void)placeWeatherConditionsIcons:(NSArray*)weatherConditions {
    int currentIconIndex = 0;
    int iconsTotal = (int)[weatherConditions count];
    for (NSDictionary *condDict in weatherConditions) {
        [self createIconViewWithIconURL:[OWMAPIManager getIconFullUrlWithIconId:condDict[@"icon"]] description:condDict[@"description"] iconsTotal:iconsTotal andCurrentIconIndex:currentIconIndex];
        currentIconIndex++;
    }
}

#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    locationManager.delegate = nil;
    locationManager = nil;
    CLLocation *newLocation = [locations lastObject];
    [self getInfoOfLocation:newLocation completion:^(LocationInfo *locationInfo) {
        [OWMAPIManager getCurrentWeatherByCityname:locationInfo.locality withCompletionHandler:^(NSError *error, NSDictionary *result) {
            if (error) {
                NSLog(@"%@", error);
            } else {
                self.temperatureValueLabel.text = [NSString stringWithFormat:@"%.1f°C", [result[@"main"][@"temp"] floatValue]];
                self.currentCityLabel.text = [NSString stringWithFormat:@"%@, %@", result[@"name"], result[@"sys"][@"country"]];
                self.sunriseTimeLabel.text = [NSString stringWithFormat:@"Sunrise time: %@", result[@"sys"][@"sunrise"]];
                self.sunsetTimeLabel.text = [NSString stringWithFormat:@"Sunset time: %@", result[@"sys"][@"sunset"]];
                
                [self placeWeatherConditionsIcons:result[@"weather"]];
                
                [self.activity stopAnimating];
            }
        }];
    }];
}

@end
