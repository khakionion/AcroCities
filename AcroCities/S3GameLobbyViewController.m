//
//  S3GameLobbyViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/17/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3GameLobbyViewController.h"

@interface S3GameLobbyViewController ()

@end

@implementation S3GameLobbyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lobbyNavBar topItem].title = [self.lobbyObject valueForKey:@"lobbyName"];
    NSArray *acroList = [self.lobbyObject valueForKey:@"acronyms"];
    [self.activeAcronym setText:(NSString*)[acroList lastObject]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)leaveLobby:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"Now we've got: %@",string);
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"Submitting.");
    [textField resignFirstResponder];
    return YES;
}

@end
