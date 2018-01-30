//
//  ViewController.h
//  WeatherApp
//
//  Created by Nikita Votyakov on 23.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "OpenWeatherMapAPIManager.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    OpenWeatherMapAPIManager *OWMAPIManager;
}

@property (weak, nonatomic) IBOutlet UILabel *temperatureValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentCityLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *weatherIconsView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end