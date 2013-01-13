//
//  S3GameCreatingViewController.h
//  AcroCities
//
//  Created by Michael Herring on 1/7/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S3GameCreatingViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *creationSpinner;
@property (weak, nonatomic) IBOutlet UITextField *lobbyNameField;
- (IBAction)createGame:(id)sender;
- (IBAction)cancelAction:(id)sender;

@end
