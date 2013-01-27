//
//  S3IntroViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3IntroViewController.h"
#import "S3LoginRegisterViewController.h"
#import "S3MyGamesViewController.h"
#import "S3GamePoint.h"
#import "S3GameLobbyViewController.h"
#import "S3GameCreatingViewController.h"

#import <GameKit/GameKit.h>
#import <Parse/Parse.h>

@interface S3IntroViewController () {
    IBOutlet UIViewController *_loginVC;
    PFGeoPoint *_lastKnownCurrentLocation;
    NSArray *_lastKnownGames;
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
    if ([PFUser currentUser] == nil) {
        [self presentViewController:_loginVC animated:YES completion:^(){}];
    }
    else {
        self.loggedInLabel.text = [NSString stringWithFormat:@"Logged in as %@",[[PFUser currentUser] email]];
        
        __weak __typeof(&*self)weakSelf = self;
        if ([[GKLocalPlayer localPlayer] isAuthenticated] == NO) {
            [[GKLocalPlayer localPlayer] setAuthenticateHandler:^void(UIViewController* vc, NSError* err){
                if(err) {
                    NSLog(@"GameKit: %@",[err localizedDescription]);
                }
                else if([[GKLocalPlayer localPlayer] isAuthenticated]) {
                    NSLog(@"Logged in to Game Center.");
                }
                else if(vc) {
                    [weakSelf presentViewController:vc animated:YES completion:nil];
                }
            }];
        }

        
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint* pfLoc, NSError *locError) {
            if (locError == nil) {
                _lastKnownCurrentLocation = pfLoc;
                CLLocationCoordinate2D clLoc = CLLocationCoordinate2DMake([pfLoc latitude], [pfLoc longitude]);
                [self.mapView setCenterCoordinate:clLoc];
                MKCoordinateRegion mkRegion = MKCoordinateRegionMake(clLoc, MKCoordinateSpanMake(0.33, 0.33));
                [self.mapView setRegion:mkRegion];
                [S3GameSearching gamesNearLatitude:clLoc.latitude longitude:clLoc.longitude withinRange:500 notifyTarget:self];
            }
        }];
    }
}

- (IBAction)showMyGames:(id)sender {
    S3MyGamesViewController * mgvc = [[S3MyGamesViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:mgvc animated:YES completion:^(){}];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [self presentViewController:_loginVC animated:YES completion:^(){}];
}

- (IBAction)startNewGame:(id)sender {
    S3GameCreatingViewController * gcvc = [[S3GameCreatingViewController alloc] initWithNibName:nil bundle:nil];
    if(self.mapView.userLocation != nil) {
        _lastKnownCurrentLocation = [PFGeoPoint geoPointWithLocation:self.mapView.userLocation.location];
    }
    if (_lastKnownCurrentLocation != nil) {
        [gcvc setGameLocation:_lastKnownCurrentLocation];
    }
    [self presentViewController:gcvc animated:YES completion:^{}];
}

#pragma mark - S3GameResultHandler

- (void)foundGames:(NSArray *)gameArray fromSearchType:(kS3GameSearchType)searchType {
    for (PFObject *nextGame in gameArray) {
        BOOL match = NO;
        for (PFObject *nextCachedGame in _lastKnownGames) {
            if ([nextCachedGame.objectId isEqualToString:nextGame.objectId] == YES) {
                match = YES;
            }
        }
        if (!match) {
            S3GamePoint *nextPoint = [[S3GamePoint alloc] initWithGame:nextGame];
            [self.mapView addAnnotation:nextPoint];
        }
    }
    _lastKnownGames = gameArray;
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString * pinID = @"S3GamePinIdentifier";
    if ([annotation isKindOfClass:[S3GamePoint class]]) {
        MKPinAnnotationView *gamePin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pinID];
        if (!gamePin) {
            gamePin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pinID];
        }
        [gamePin setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
        gamePin.canShowCallout = YES;
        gamePin.animatesDrop = YES;
        return gamePin;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if ([view.annotation isKindOfClass:[S3GamePoint class]]) {
        S3GamePoint *gamePoint = [view annotation];
        PFObject *game = gamePoint.game;
        S3GameLobbyViewController *glvc = [[S3GameLobbyViewController alloc] initWithNibName:nil bundle:nil];
        [glvc setLobbyObject:game];
        [self presentViewController:glvc animated:YES completion:^{}];
    }
}

@end
