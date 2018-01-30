//
//  SidebarTableViewController.m
//  WeatherApp
//
//  Created by Nikita Votyakov on 29.01.18.
//  Copyright © 2018 Nikita Votyakov. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "ViewController.h"
#import "MenuTableViewCell.h"

@interface SidebarTableViewController ()

@end

static NSString * const reuseHeaderIdentifier = @"headerCell";
static NSString * const reuseIdentifier = @"menuCell";

@implementation SidebarTableViewController {
    NSArray *menuItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_background"]];
    
    menuItems = @[@"Perm", @"Saint Petersburg", @"Moscow", @"city4", @"city5"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.cityLabel.text = menuItems[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:reuseHeaderIdentifier];
    return headerCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *navController = segue.destinationViewController;
    ViewController *mainVC = [navController childViewControllers].firstObject;
    mainVC.selectedCity = menuItems[indexPath.row];
}

@end
