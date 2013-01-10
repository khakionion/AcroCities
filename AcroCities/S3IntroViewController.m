//
//  S3IntroViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3IntroViewController.h"
#import "S3GameFindingViewController.h"

#import <GameKit/GameKit.h>
#import <Parse/Parse.h>

@interface S3IntroViewController ()

@end

@implementation S3IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    /*PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];*/
    
    //make the title look nice
    NSMutableAttributedString* text = [[self.titleLabel attributedText] mutableCopy];
    [text addAttribute:NSKernAttributeName value:@-2.0 range:NSMakeRange(0, [text length])];
    [self.titleLabel setAttributedText:text];
}

- (void)viewDidAppear:(BOOL)animated {
    //log us in yo
    if ([PFUser currentUser] == nil) {
        [UIView animateWithDuration:1.0f animations:^(){
            [self.registrationView setAlpha:1.0f];
        }];
    }
    else {
        self.loggedInLabel.text = [NSString stringWithFormat:@"Logged in as %@",[[PFUser currentUser] email]];
        [self.loggedInView setAlpha:0.0f];
        [UIView animateWithDuration:1.0f animations:^(){
            [self.loggedInView setAlpha:1.0f];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showMyGames:(id)sender {
}

- (IBAction)findGames:(id)sender {
    S3GameFindingViewController * gfvc = [[S3GameFindingViewController alloc] initWithNibName:@"S3GameFindingViewController" bundle:nil];
    [self presentViewController:gfvc animated:YES completion:^(){}];
}

- (IBAction)registerUser:(id)sender {
    PFUser * user = [PFUser user];
    NSString * lowercaseInput = [self.usernameField.text lowercaseString];
    [user setUsername:lowercaseInput];
    [user setEmail:lowercaseInput];
    [user setPassword:self.passwordField.text];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError* err){
        if (succeeded) {
            self.loggedInLabel.text = [NSString stringWithFormat:@"Logged in as %@",[[PFUser currentUser] email]];
            [UIView animateWithDuration:1.0f animations:^(){
                [self.registrationView setAlpha:0.0f];
                [self.loggedInView setAlpha:1.0f];
                
            }];
        }
        else {
            [self displayLoginError:err];
        }
    }];
}

- (IBAction)loginUser:(id)sender {
    NSString * lowercaseInput = [self.usernameField.text lowercaseString];
    [PFUser logInWithUsernameInBackground:lowercaseInput password:self.passwordField.text block:^(PFUser* user,NSError* err){
        if (err == nil) {
            self.loggedInLabel.text = [NSString stringWithFormat:@"Logged in as %@",[[PFUser currentUser] email]];
            [UIView animateWithDuration:1.0f animations:^(){
                [self.registrationView setAlpha:0.0f];
                [self.loggedInView setAlpha:1.0f];
            }];
        }
        else {
            [self displayLoginError:err];
        }
    }];
}

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [self.loggedInView setAlpha:0.0f];
    [self.registrationView setAlpha:1.0f];
    [self.loadingSpinner setAlpha:0.0f];
    [self.usernameField setText:@""];
    [self.passwordField setText:@""];
}

-(void) displayLoginError:(NSError*)err {
    UIAlertView * loginFailAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [loginFailAlert show];
}

#pragma mark - UITextFieldDelegate


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }
    else if(textField == self.passwordField) {
        [self.passwordField resignFirstResponder];
    }
    return YES;
}


@end
