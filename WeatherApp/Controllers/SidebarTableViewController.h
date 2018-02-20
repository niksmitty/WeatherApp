//
//  SidebarTableViewController.h
//  WeatherApp
//
//  Created by Nikita Votyakov on 29.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CitySelectorViewController.h"

@interface SidebarTableViewController : UITableViewController<UIPopoverPresentationControllerDelegate, CitySelectorViewControllerDelegate>

@end
