//
//  S3IntroViewController.h
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "S3GameSearching.h"
#import "S3GameMapViewController.h"

@interface S3IntroViewController : UIViewController <MKMapViewDelegate, S3GameMapDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//UI for logged in users
@property (weak, nonatomic) IBOutlet UILabel *loggedInLabel;
@property (weak, nonatomic) IBOutlet UILabel *globalGamesLabel;
@property (weak, nonatomic) IBOutlet UIButton *createGameButton;
@property (weak, nonatomic) IBOutlet UIButton *myGamesButton;
@property (strong, nonatomic) IBOutlet S3GameMapViewController *mapController;

- (IBAction)showMyGames:(id)sender;
- (IBAction)logOut:(id)sender;
- (IBAction)startNewGame:(id)sender;
- (IBAction)reportBug:(id)sender;


@end
