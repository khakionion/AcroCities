//
//  S3GameLobbyViewController.h
//  AcroCities
//
//  Created by Michael Herring on 1/17/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface S3GameLobbyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *activeAcronym;
@property (strong) PFObject* lobbyObject;
@property (weak, nonatomic) IBOutlet UITextField *answerField;
@property (weak, nonatomic) IBOutlet UINavigationBar *lobbyNavBar;
@property (weak, nonatomic) IBOutlet UILabel *answerPromptLabel;
@property (weak, nonatomic) IBOutlet UILabel *votingPromptLabel;
@property (weak, nonatomic) IBOutlet UITableView *votingTableView;
- (IBAction)leaveLobby:(id)sender;

@end
