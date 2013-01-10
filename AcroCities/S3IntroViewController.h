//
//  S3IntroViewController.h
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S3IntroViewController : UIViewController

//basic view layout
@property (weak, nonatomic) IBOutlet UIView *loadingSpinner;
@property (weak, nonatomic) IBOutlet UIView *registrationView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

//UI for registration
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

//UI for logged in users
@property (strong, nonatomic) IBOutlet UIView *loggedInView;
@property (weak, nonatomic) IBOutlet UILabel *loggedInLabel;
@property (weak, nonatomic) IBOutlet UIButton *findGameButton;
@property (weak, nonatomic) IBOutlet UIButton *myGamesButton;

- (IBAction)showMyGames:(id)sender;
- (IBAction)findGames:(id)sender;
- (IBAction)registerUser:(id)sender;
- (IBAction)loginUser:(id)sender;
- (IBAction)logOut:(id)sender;

@end
