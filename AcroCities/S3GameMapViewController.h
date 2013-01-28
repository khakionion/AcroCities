//
//  S3GameMapViewController.h
//  AcroCities
//
//  Created by Michael Herring on 1/27/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "S3GamePoint.h"
#import "S3GameSearching.h"

@class S3GameMapViewController;

@protocol S3GameMapDelegate <NSObject>

@required

- (void)gameMapViewController:(S3GameMapViewController*)gmvc didSelectGamePoint:(S3GamePoint*)gamePoint;

@end

@interface S3GameMapViewController : UIViewController <MKMapViewDelegate, S3GameResultHandler>

@property (readwrite, weak) IBOutlet id <S3GameMapDelegate> delegate;
@property (readwrite) IBOutlet MKMapView *mapView;

@end
