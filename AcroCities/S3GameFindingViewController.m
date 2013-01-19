//
//  S3GameFindingViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/6/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3GameFindingViewController.h"
#import "S3GameCreatingViewController.h"

#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface S3GameFindingViewController () {
    BOOL _searchingPlaces;
    NSArray * _foundGames;
    NSArray * _foundPlaces;
    PFGeoPoint * _currentLocation;
}

-(void)searchForNearbyGames;

@end

@implementation S3GameFindingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint* geoPoint, NSError* error) {
        if (error != nil) {
            NSLog(@"geopoint error: %@",[error localizedDescription]);
        }
        else {
            _currentLocation = geoPoint;
            [self searchForNearbyGames];
        }
    }];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_searchingPlaces == NO && [_foundGames count] > 0) {
        return [_foundGames count];
    }
    else if([_foundPlaces count] > 0) {
        return [_foundPlaces count];
    }
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * placeName = @"Invalid Name";
    if (_searchingPlaces && [_foundPlaces count] > 0) {
        MKMapItem * nextItem = [_foundPlaces objectAtIndex:indexPath.row];
        if (nextItem.name) {
            placeName = nextItem.name;
        }
    }
    else if([_foundGames count] > 0) {
        PFObject* nextGame = [_foundGames objectAtIndex:indexPath.row];
        if ([nextGame valueForKey:@"lobbyName"]) {
            placeName = [nextGame valueForKey:@"lobbyName"];
        }
    }
    else {
        UITableViewCell* newCell = [tableView dequeueReusableCellWithIdentifier:@"NoneFound"];
        if (newCell == nil) {
            newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NoneFound"];
        }
        placeName = @"No nearby games. :(";
    }
    UITableViewCell* newCell = [tableView dequeueReusableCellWithIdentifier:@"Venue"];
    if (newCell == nil) {
        newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Venue"];
    }
    [[newCell textLabel] setText:placeName];
    return newCell;
}

#pragma mark - Core location delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    NSLog(@"Found location.");
}

- (void)doSearch {
}

- (IBAction)createNewGame:(id)sender {
    S3GameCreatingViewController * gcvc = [[S3GameCreatingViewController alloc] initWithNibName:@"S3GameCreatingViewController" bundle:nil];
    [self presentViewController:gcvc animated:YES completion:^(){
        [gcvc setGameLocation:_currentLocation];
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    MKLocalSearchRequest * mySearchRequest = [[MKLocalSearchRequest alloc] init];
    mySearchRequest.naturalLanguageQuery = searchBar.text;
    CLLocationCoordinate2D clLoc = CLLocationCoordinate2DMake(_currentLocation.latitude, _currentLocation.longitude);
    mySearchRequest.region = MKCoordinateRegionMakeWithDistance(clLoc, 500, 500);
    MKLocalSearch* mySearch = [[MKLocalSearch alloc] initWithRequest:mySearchRequest];
    [mySearch startWithCompletionHandler:^(MKLocalSearchResponse* resp, NSError* err){
        if (err == nil && [resp.mapItems count] > 0) {
            _foundPlaces = resp.mapItems;
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
        else if(err != nil) {
            NSLog(@"Map Error: %@",[err localizedDescription]);
        }
    }];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSLog(@"reloading data for search string: %@",searchString);
    _searchingPlaces = YES;
    return YES;
}

- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    _searchingPlaces = NO;
}

#pragma mark - private implementation

- (void)searchForNearbyGames {
    PFQuery* nearbyGamesQuery = [PFQuery queryWithClassName:@"Game"];
    NSNumber* gameSearchRadius = [[NSUserDefaults standardUserDefaults] valueForKey:@"GameSearchRadius"];
    [nearbyGamesQuery whereKey:@"centroid" nearGeoPoint:_currentLocation withinKilometers:[gameSearchRadius floatValue]];
    [nearbyGamesQuery findObjectsInBackgroundWithBlock:^(NSArray* objects, NSError* error){
        _foundGames = objects;
        [self.tableView reloadData];
    }];
}

@end
