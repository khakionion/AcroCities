//
//  S3IntroViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3IntroViewController.h"

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
        [UIView animateWithDuration:1.0f animations:^(){
            [self.loadingSpinner setAlpha:1.0f];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerUser:(id)sender {
    PFUser * user = [PFUser user];
    NSString * lowercaseInput = [self.usernameField.text lowercaseString];
    [user setUsername:lowercaseInput];
    [user setEmail:lowercaseInput];
    [user setPassword:self.passwordField.text];
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError* err){
        if (succeeded) {
            NSLog(@"signup successful.");
        }
        else {
            NSLog(@"Oh dear, failed to sign up.");
        }
    }];
}

- (IBAction)loginUser:(id)sender {
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
