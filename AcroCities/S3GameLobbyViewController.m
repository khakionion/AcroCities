//
//  S3GameLobbyViewController.m
//  AcroCities
//
//  Created by Michael Herring on 1/17/13.
//  Copyright (c) 2013 Sun, Sea and Sky Factory. All rights reserved.
//

#import "S3GameLobbyViewController.h"

@interface S3GameLobbyViewController () {
    NSArray *_lobbyAnswers;
}

- (void)ownAnswerQueryReturned:(NSArray *)result error:(NSError *)error;
- (void)lobbyAnswerQueryReturned:(NSArray *)result error:(NSError *)error;
- (void)findLobbyAnswers;
- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
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
    [self.votingTableView setHidden:YES];
    [self.votingPromptLabel setHidden:YES];
    PFQuery *answerQuery = [PFQuery queryWithClassName:@"Answer"];
    [answerQuery whereKey:@"user" equalTo:[PFUser currentUser]];
    [answerQuery whereKey:@"game" equalTo:self.lobbyObject];
    [answerQuery findObjectsInBackgroundWithTarget:self selector:@selector(ownAnswerQueryReturned:error:)];
}

- (IBAction)leaveLobby:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^(){}];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    PFObject *answer = [PFObject objectWithClassName:@"Answer"];
    [answer setValue:[PFUser currentUser] forKey:@"user"];
    [answer setValue:self.lobbyObject forKey:@"game"];
    [[answer mutableArrayValueForKey:@"guesses"] addObject:textField.text];
    [textField resignFirstResponder];
    [answer saveEventually:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *answerAlert = [[UIAlertView alloc] initWithTitle:@"Failed To Save Answer" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Darn!" otherButtonTitles:nil];
            [answerAlert show];
        }
        [self dismissViewControllerAnimated:YES completion:^{}];
    }];
    return YES;
}

- (void)ownAnswerQueryReturned:(NSArray *)result error:(NSError *)error {
    NSArray *acronyms = [self.lobbyObject valueForKey:@"acronyms"];
    NSArray *guesses = [[result lastObject] valueForKey:@"guesses"];
    if ([acronyms count] == [guesses count]) {
        self.answerField.borderStyle = UITextBorderStyleNone;
        self.answerField.enabled = NO;
        self.answerField.text = [guesses lastObject];
        self.answerPromptLabel.text = NSLocalizedString(@"You answered: ", @"Prompt text that indicates the user has already answered this acronym.");
        //since the user has answered, we find everyone else's answers now
        [self findLobbyAnswers];
    }
}

- (void)findLobbyAnswers {
    PFQuery *answerQuery = [PFQuery queryWithClassName:@"Answer"];
    [answerQuery whereKey:@"game" equalTo:self.lobbyObject];
    [answerQuery whereKey:@"user" notEqualTo:[PFUser currentUser]];
    [answerQuery findObjectsInBackgroundWithTarget:self selector:@selector(lobbyAnswerQueryReturned:error:)];
}

- (void)lobbyAnswerQueryReturned:(NSArray *)result error:(NSError *)error {
    if (error == nil) {
        NSPredicate *thisRoundOnly = [NSPredicate predicateWithFormat:@"guesses.@count == %i", [[self.lobbyObject valueForKey:@"acronyms"] count]];
        _lobbyAnswers = [result filteredArrayUsingPredicate:thisRoundOnly];
        [self.votingTableView reloadData];
        [self.votingPromptLabel setHidden:NO];
        [self.votingTableView setHidden:NO];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_lobbyAnswers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [[[_lobbyAnswers objectAtIndex:indexPath.row] valueForKey:@"guesses"] lastObject];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
