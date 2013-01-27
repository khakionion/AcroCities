//
//  S3LoginRegisterViewController.h
//  AcroCities
//
//  Created by Michael Herring on 1/26/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S3LoginRegisterViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginOrRegisterUser:(id)sender;
- (void)displayLoginError:(NSError*)err;

@end
