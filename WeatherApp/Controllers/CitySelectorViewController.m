//
//  CitySelectorViewController.m
//  WeatherApp
//
//  Created by Nikita Votyakov on 19.02.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import "CitySelectorViewController.h"
#import "CityValueCell.h"

@interface CitySelectorViewController () {
    BOOL isCitiesListLoading;
}

@end

@implementation CitySelectorViewController

static NSString * const reuseIdentifier = @"CityValueCell";

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isCitiesListLoading = NO;
    notFoundLabel.hidden = YES;
    
    [tableView registerNib:[UINib nibWithNibName:@"CityValueCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_background"]];
    backgroundImageView.alpha = 0.5;
    tableView.backgroundView = backgroundImageView;
    
    self.navigationItem.title = NSLocalizedString(@"Choose city", @"");

    [self setupSearchController];
}

-(void)setupSearchController {
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.placeholder = NSLocalizedString(@"Search cities", @"");
    [searchController.searchBar sizeToFit];
    tableView.tableHeaderView = searchController.searchBar;
    
    searchController.delegate = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.searchBar.delegate = self;
    searchController.definesPresentationContext = YES;
}

#pragma mark - Data loading and filtering methods

-(void)loadCitiesList {
    NSError *error;
    NSString *citiesListFilePath = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"json"];
    NSString *citiesListJsonString = [NSString stringWithContentsOfFile:citiesListFilePath
                                                               encoding:NSUTF8StringEncoding
                                                                  error:&error];
    if (!error) {
        NSArray *citiesListObject = [NSJSONSerialization JSONObjectWithData:[citiesListJsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        if (!error) {
            citiesListObject = [citiesListObject sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
            originalCities = cities = [NSMutableArray new];
            for (NSDictionary *cityInfo in citiesListObject) {
                [cities addObject:[City cityFromDictionary:cityInfo]];
            }
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    } else {
        NSLog(@"%@", error.localizedDescription);
    }
}

-(void)filterCitiesBySearchText:(NSString*)searchText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH [search] %@", searchText];
    NSArray *searchResults = [originalCities filteredArrayUsingPredicate:predicate];
    cities = [NSMutableArray arrayWithArray:searchResults];
    notFoundLabel.hidden = cities.count == 0 ? NO : YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->tableView reloadData];
    });
}

#pragma mark - Table View datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cities count];
}

-(UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityValueCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.cityValueLabel.text = [NSString stringWithFormat:@"%@, %@", cities[indexPath.row].name, cities[indexPath.row].country];
    
    return cell;
}

#pragma mark - Table View delegate

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityValueCell *cell = (CityValueCell*)[_tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    
    [searchController dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate) [self.delegate cityValueWasSelected:cities[indexPath.row]];
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)_searchController {
    if (_searchController.searchBar.text.length != 0) {
        if (!isCitiesListLoading) {
            if (!originalCities) {
                
                isCitiesListLoading = YES;
                notFoundLabel.hidden = YES;
                [activity startAnimating];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    
                    [self loadCitiesList];
                    self->isCitiesListLoading = NO;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self->activity stopAnimating];
                        [self filterCitiesBySearchText:_searchController.searchBar.text];
                    });
                    
                });
            } else {
                [self filterCitiesBySearchText:_searchController.searchBar.text];
            }
        }
    } else {
        cities = nil;
        notFoundLabel.hidden = YES;
        [tableView reloadData];
    }
}

@end
