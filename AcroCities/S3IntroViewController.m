//
//  S3IntroViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3IntroViewController.h"
#import "S3LoginRegisterViewController.h"
#import "S3GameFindingViewController.h"
#import "S3MyGamesViewController.h"

#import <GameKit/GameKit.h>
#import <Parse/Parse.h>

@interface S3IntroViewController () {
    
    IBOutlet UIViewController *_loginVC;
}

@end

@implementation S3IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	//make the title look nice
    NSMutableAttributedString* text = [[self.titleLabel attributedText] mutableCopy];
    [text addAttribute:NSKernAttributeName value:@-2.0 range:NSMakeRange(0, [text length])];
    [self.titleLabel setAttributedText:text];
}

- (void)viewDidAppear:(BOOL)animated {
    //log us in yo
    if ([PFUser currentUser] == nil) {
        [self presentViewController:_loginVC animated:YES completion:^(){}];
    }
    else {
        self.loggedInLabel.text = [NSString stringWithFormat:@"Logged in as %@",[[PFUser currentUser] email]];
        
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint* pfLoc, NSError *locError) {
            CLLocationCoordinate2D clLoc = CLLocationCoordinate2DMake([pfLoc latitude], [pfLoc longitude]);
            [self.mapView setCenterCoordinate:clLoc];
            MKCoordinateRegion mkRegion = MKCoordinateRegionMake(clLoc, MKCoordinateSpanMake(0.33, 0.33));
            [self.mapView setRegion:mkRegion];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMyGames:(id)sender {
    S3MyGamesViewController * mgvc = [[S3MyGamesViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:mgvc animated:YES completion:^(){}];
}

- (IBAction)findGames:(id)sender {
    S3GameFindingViewController * gfvc = [[S3GameFindingViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:gfvc animated:YES completion:^(){}];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
}

@end
