//
//  S3GameFindingViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/6/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3GameFindingViewController.h"

#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface S3GameFindingViewController () {
    NSArray * _foundPlaces;
    CLLocationManager * _locationManager;
}

@end

@implementation S3GameFindingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _locationManager = [[CLLocationManager alloc] init];
        [_locationManager setDelegate:self];
        [_locationManager startUpdatingLocation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_foundPlaces) {
        return [_foundPlaces count];
    }
    else return 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * placeName = @"No places found...";
    if (_foundPlaces && [_foundPlaces count] > 0) {
        MKMapItem * nextItem = [_foundPlaces objectAtIndex:indexPath.row];
        placeName = nextItem.name;
    }
    UITableViewCell* newCell = [tableView dequeueReusableCellWithIdentifier:@"Venue"];
    if (newCell == nil) {
        newCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Venue"];
    }
    [[newCell textLabel] setText:placeName];
    return newCell;
}

#pragma mark - Core location delegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    NSLog(@"Found location. Beginning search.");
    MKLocalSearchRequest * mySearchRequest = [[MKLocalSearchRequest alloc] init];
    mySearchRequest.naturalLanguageQuery = @"coffee";
    mySearchRequest.region = MKCoordinateRegionMakeWithDistance(_locationManager.location.coordinate, 100, 100);
    MKLocalSearch* mySearch = [[MKLocalSearch alloc] initWithRequest:mySearchRequest];
    [mySearch startWithCompletionHandler:^(MKLocalSearchResponse* resp, NSError* err){
        if (err == nil && [resp.mapItems count] > 0) {
            _foundPlaces = resp.mapItems;
            [self.tableView reloadData];
        }
        else if(err != nil) {
            NSLog(@"Map Error: %@",[err localizedDescription]);
        }
    }];
}

@end
