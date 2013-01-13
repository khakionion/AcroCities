//
//  S3GameCreatingViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/7/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3GameCreatingViewController.h"

#import <Parse/Parse.h>

@interface S3GameCreatingViewController ()

@end

@implementation S3GameCreatingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createGame:(id)sender {
    PFObject *gameObject = [PFObject objectWithClassName:@"Game"];
    [gameObject setObject:[[PFUser currentUser] email] forKey:@"creator"];
    [gameObject setObject:self.lobbyNameField.text forKey:@"lobbyName"];
    [self.creationSpinner startAnimating];
    [gameObject saveInBackgroundWithBlock:^(BOOL success, NSError* error){
        [self dismissViewControllerAnimated:YES completion:^(){}];
        [self.creationSpinner stopAnimating];
    }];
}

- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){}];
}
@end
