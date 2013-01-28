//
//  S3GameMapViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/27/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3GameMapViewController.h"
#import "S3GameLobbyViewController.h"

@interface S3GameMapViewController () {
    PFGeoPoint *_lastKnownCurrentLocation;
    NSArray *_lastKnownGames;
}

@end

@implementation S3GameMapViewController

- (void)viewDidAppear:(BOOL)animated {
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
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(gameMapViewController:didSelectGamePoint:)]) {
                [self.delegate performSelector:@selector(gameMapViewController:didSelectGamePoint:) withObject:gamePoint];
            }
        }
    }
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

@end
