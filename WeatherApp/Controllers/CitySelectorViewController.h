//
//  CitySelectorViewController.h
//  WeatherApp
//
//  Created by Nikita Votyakov on 19.02.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@protocol CitySelectorViewControllerDelegate <NSObject>

-(void)cityValueWasSelected:(City*)cityInfo;

@end

@interface CitySelectorViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating> {
    __weak IBOutlet UITableView *tableView;
    __weak IBOutlet UIActivityIndicatorView *activity;
    __weak IBOutlet UILabel *notFoundLabel;
    
    NSMutableArray<City *> *cities, *originalCities;
    
    UISearchController *searchController;
}

@property (nonatomic, weak) id<CitySelectorViewControllerDelegate> delegate;

@end
