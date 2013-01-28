//
//  S3MyGamesViewController.h
//  AcroCities
//
//  Created by Michael Herring on 1/9/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface S3MyGamesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableViewController *tableViewController;

- (IBAction)cancelAction:(id)sender;

@end
