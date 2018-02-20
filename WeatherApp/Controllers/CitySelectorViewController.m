//
//  CitySelectorViewController.m
//  WeatherApp
//
//  Created by Nikita Votyakov on 19.02.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import "CitySelectorViewController.h"
#import "CityValueCell.h"

@interface CitySelectorViewController ()

@end

@implementation CitySelectorViewController

static NSString * const reuseIdentifier = @"CityValueCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [tableView registerNib:[UINib nibWithNibName:@"CityValueCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_background"]];
    
    self.navigationItem.title = @"Choose city from list";

    [self setupSearchController];
    
    [self loadCitiesList];
}

-(void)setupSearchController {
    searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.placeholder = @"Search cities";
    [searchController.searchBar sizeToFit];
    tableView.tableHeaderView = searchController.searchBar;
    
    searchController.delegate = self;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.searchBar.delegate = self;
    searchController.definesPresentationContext = YES;
}

-(void)loadCitiesList {
    NSError *error;
    NSString *citiesListFilePath = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"json"];
    NSString *citiesListJsonString = [NSString stringWithContentsOfFile:citiesListFilePath
                                                               encoding:NSUTF8StringEncoding
                                                                  error:&error];
    if (!error) {
        NSArray *citiesListObject = [NSJSONSerialization JSONObjectWithData:[citiesListJsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        originalCities = cities = [citiesListObject valueForKeyPath:@"name"];
    }
}

#pragma mark - Table View datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [cities count];
}

-(UITableViewCell*)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CityValueCell *cell = [_tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.cityValueLabel.text = cities[indexPath.row];
    
    return cell;
}

#pragma mark - Table View delegate

-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CityValueCell *cell = (CityValueCell*)[_tableView cellForRowAtIndexPath:indexPath];
    cell.selected = YES;
    
    [searchController dismissViewControllerAnimated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (self.delegate) [self.delegate cityValueWasSelected:cell.cityValueLabel.text];
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - UISearchControllerDelegate

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)_searchController {
    NSString *searchText = _searchController.searchBar.text;
    
    if ([searchText length] == 0)
    {
        cities = originalCities;
    }
    else
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [search] %@", searchText];
        NSArray *searchResults = [originalCities filteredArrayUsingPredicate:predicate];
        cities = searchResults;
    }
    
    [tableView reloadData];
}

@end
