//
//  S3IntroViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/5/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3IntroViewController.h"

#import <Parse/Parse.h>

@interface S3IntroViewController ()

@end

@implementation S3IntroViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    [testObject setObject:@"bar" forKey:@"foo"];
    [testObject save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendPush:(id)sender {
    NSError * err = nil;
    BOOL result = [PFPush sendPushMessageToChannel:@"" withMessage:@"OH HELLO GUYZ" error:&err];
    if (!result) {
        NSLog(@"Oops. %@",[err localizedDescription]);
    }
}
@end
