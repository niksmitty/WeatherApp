//
//  AppDelegate.h
//  WeatherApp
//
//  Created by Nikita Votyakov on 23.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

