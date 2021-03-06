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
#import "AppDelegate.h"

@interface SidebarTableViewController ()

@end

static NSString * const reuseHeaderIdentifier = @"headerCell";
static NSString * const reuseIdentifier = @"menuCell";

@implementation SidebarTableViewController {
    NSMutableArray *menuItems;
    
    NSManagedObjectContext *managedContext;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    managedContext = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sidebar_background"]];
    backgroundImageView.alpha = 0.5;
    self.tableView.backgroundView = backgroundImageView;
    
    menuItems = [self fetchCitiesFromDB];
}

#pragma mark - Actions

- (IBAction)addButtonTapped:(id)sender {
    CitySelectorViewController *citySVC = [CitySelectorViewController new];
    citySVC.delegate = self;
    citySVC.modalPresentationStyle = UIModalPresentationPopover;
    
    UIPopoverPresentationController *popover = citySVC.popoverPresentationController;
    popover.delegate = self;
    popover.sourceView = ((UIButton*)sender).superview;
    popover.sourceRect = ((UIButton*)sender).frame;
    popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    
    [self presentViewController:citySVC animated:YES completion:nil];
}

#pragma mark - Work with Core Data

-(void)saveDataIntoDBWithCityInfo:(City*)cityInfo {
    NSManagedObject *cityObject = [NSEntityDescription insertNewObjectForEntityForName:@"City" inManagedObjectContext:managedContext];
    [cityObject setValue:cityInfo.identifier forKey:@"id"];
    [cityObject setValue:cityInfo.name forKey:@"name"];
    [cityObject setValue:cityInfo.country forKey:@"country"];
    [cityObject setValue:cityInfo.longitude forKey:@"lon"];
    [cityObject setValue:cityInfo.latitude forKey:@"lat"];
    
    NSError *error = nil;
    if ([managedContext save:&error]) {
        [menuItems addObject:cityObject];
    } else {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
    
}

-(NSMutableArray*)fetchCitiesFromDB {
    NSMutableArray *cities = [NSMutableArray new];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"City"];
    NSError *error = nil;
    NSArray *results = [managedContext executeFetchRequest:request error:&error];
    if (!results) {
        NSLog(@"Error fetching City objects: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    } else {
        for (NSManagedObject *cityObject in results) {
            [cities addObject:cityObject];
        }
    }
    
    return cities;
}

-(void)deleteCityFromDB:(NSManagedObject*)cityObject {
    [managedContext deleteObject:cityObject];
    
    NSError *error;
    if (![managedContext save:&error]) {
        NSAssert(NO, @"Error saving context: %@\n%@", [error localizedDescription], [error userInfo]);
    }
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [menuItems count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.cityLabel.text = [NSString stringWithFormat:@"%@, %@", [menuItems[indexPath.row] valueForKey:@"name"], [menuItems[indexPath.row] valueForKey:@"country"]];
    return cell;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCityFromDB:menuItems[indexPath.row]];
        [menuItems removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView setEditing:NO animated:YES];
    }
}

#pragma mark - Table view delegate

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewCell *headerCell = [tableView dequeueReusableCellWithIdentifier:reuseHeaderIdentifier];
    return headerCell.contentView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60.0;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"-";
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *navController = segue.destinationViewController;
    ViewController *mainVC = [navController childViewControllers].firstObject;
    mainVC.selectedCity = [City cityFromManagedObject:menuItems[indexPath.row]];
}

#pragma mark - Popover Presentation Controller Delegate

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationFullScreen;
}

-(UIViewController*)presentationController:(UIPresentationController *)controller viewControllerForAdaptivePresentationStyle:(UIModalPresentationStyle)style {
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller.presentedViewController];
    UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"")
                                                               style:UIBarButtonItemStyleDone
                                                              target:self
                                                              action:@selector(dismiss)];
    bbItem.tintColor = [UIColor blackColor];
    navController.topViewController.navigationItem.rightBarButtonItem = bbItem;
    return navController;
}

-(void)dismiss {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - City Selector View Controller delegate

-(void)cityValueWasSelected:(City*)cityInfo {
    [self saveDataIntoDBWithCityInfo:cityInfo];
    [self.tableView reloadData];
}

@end
