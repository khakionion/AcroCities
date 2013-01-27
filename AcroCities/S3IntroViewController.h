//
//  S3IntroViewController.h
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface S3IntroViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//UI for logged in users
@property (weak, nonatomic) IBOutlet UILabel *loggedInLabel;
@property (weak, nonatomic) IBOutlet UIButton *findGameButton;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)showMyGames:(id)sender;
- (IBAction)findGames:(id)sender;
- (IBAction)logOut:(id)sender;

@end
