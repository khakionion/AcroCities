//
//  S3LoginRegisterViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/26/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3LoginRegisterViewController.h"
#import "S3LoadingMessageViewController.h"
#import <Parse/Parse.h>

@interface S3LoginRegisterViewController ()

- (void)loginSuccess;
@end

@implementation S3LoginRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)loginOrRegisterUser:(id)sender {
    NSString * lowercaseInput = [self.usernameField.text lowercaseString];
    S3LoadingMessageViewController *lmvc = [[S3LoadingMessageViewController alloc] initWithNibName:nil bundle:nil];
    [self addChildViewController:lmvc];
    [PFUser logInWithUsernameInBackground:lowercaseInput password:self.passwordField.text block:^(PFUser* user,NSError* loginError){
        if (loginError == nil) {
            [self loginSuccess];
        }
        else {
            if ([loginError code] == kPFErrorObjectNotFound) {
                PFUser * user = [PFUser user];
                NSString * lowercaseInput = [self.usernameField.text lowercaseString];
                [user setUsername:lowercaseInput];
                [user setEmail:lowercaseInput];
                [user setPassword:self.passwordField.text];
                [user signUpInBackgroundWithBlock:^(BOOL success, NSError*signUpError) {
                    if(success == YES) {
                        [self loginSuccess];
                    }
                    else {
                        [self displayLoginError:signUpError];
                    }
                }];
            }
            else {
                [self displayLoginError:loginError];
            }
        }
    }];
}

-(void) displayLoginError:(NSError*)err {
    UIAlertView * loginFailAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[err localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [loginFailAlert show];
}

- (void)loginSuccess {
    [self dismissViewControllerAnimated:YES completion:^() {}];
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
