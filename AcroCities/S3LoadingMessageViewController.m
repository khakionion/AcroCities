//
//  S3LoadingMessageViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/26/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "S3LoadingMessageViewController.h"

@interface S3LoadingMessageViewController () {
    
    __weak IBOutlet UILabel *_messageLabel;
    __weak IBOutlet UIActivityIndicatorView *_spinner;
}

@end

@implementation S3LoadingMessageViewController

-(void) viewDidLoad {
    [self.view.layer setCornerRadius:3.0f];
}

-(void) setMessage:(NSString*)message {
    _messageLabel.text = message;
}

@end
