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
#import <QuartzCore/QuartzCore.h>

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
	//make the UI look nice
    NSMutableAttributedString* text = [[self.titleLabel attributedText] mutableCopy];
    [text addAttribute:NSKernAttributeName value:@-2.0 range:NSMakeRange(0, [text length])];
    [self.titleLabel setAttributedText:text];
    [self.myGamesButton.layer setCornerRadius:9.0f];
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
        PFQuery *allGames = [PFQuery queryWithClassName:@"Game"];
        [allGames countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error == nil) {
                self.globalGamesLabel.text = [NSString stringWithFormat:@"%i games active worldwide", number];
            }
        }];
    }
}

- (IBAction)showMyGames:(id)sender {
    S3MyGamesViewController * mgvc = [[S3MyGamesViewController alloc] initWithNibName:nil bundle:nil];
    [mgvc setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
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

#pragma mark - S3GameMapDelegate

- (void)gameMapViewController:(id)gmvc didSelectGamePoint:(S3GamePoint *)gamePoint {
    PFObject *game = gamePoint.game;
    S3GameLobbyViewController *glvc = [[S3GameLobbyViewController alloc] initWithNibName:nil bundle:nil];
    [glvc setLobbyObject:game];
    [self presentViewController:glvc animated:YES completion:^{}];
}

@end
