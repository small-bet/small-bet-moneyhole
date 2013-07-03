//
//  JDPChallengeListViewController.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPChallengeListViewController.h"
#import "JDPChallengeCell.h"
#import <SmallBet/SmallBet.h>
#import "JDPChallengeStatusViewController.h"

@interface JDPChallengeListViewController ()

@property (nonatomic, strong) NSMutableArray * challengesArray;
@property (nonatomic, strong) NSDictionary * challengeDictionary;

@property (nonatomic, strong) NSMutableArray * observers;

@end

static NSString * const kJDPChallengeCellReuseIdentifier = @"challengeCell";
static NSString * const kJDPLoadingCellReuseIdentifier = @"loading cell";
static NSString * const kJDPNoChallegesCellReuseIdentifier = @"noChallengeCell";

@implementation JDPChallengeListViewController


#pragma mark - properties

-(void)setChallengesArray:(NSMutableArray *)challengesArray{
    _challengesArray = challengesArray;

    if (challengesArray) {
        NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] initWithCapacity:challengesArray.count];
        for (SBChallenge * challenge  in challengesArray) {
            dictionary[challenge.identifier] = challenge;
        }
        self.challengeDictionary = dictionary;
    }
    else{
        self.challengeDictionary = nil;
    }
}


-(NSMutableArray *)observers{
    if (_observers) {
        return _observers;
    }

    _observers = [NSMutableArray array];
    return _observers;
}
#pragma mark - lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Challenges", nil);

    self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:0.63f saturation:0.99f brightness:0.44f alpha:1.00f];

    UINib * challengeCellNib = [UINib nibWithNibName:@"JDPChallengeCell" bundle:nil];
    [self.tableView registerNib:challengeCellNib
         forCellReuseIdentifier:kJDPChallengeCellReuseIdentifier];
    UINib * loadingCellNib = [UINib nibWithNibName:@"JDPLoadingCell" bundle:nil];
    [self.tableView registerNib:loadingCellNib
         forCellReuseIdentifier:kJDPLoadingCellReuseIdentifier];
    UINib * noChallengesNib = [UINib nibWithNibName:@"JDPNoChallengesCell" bundle:nil];
    [self.tableView registerNib:noChallengesNib
         forCellReuseIdentifier:kJDPNoChallegesCellReuseIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [SBChallenge allChallengesWithCompletion:^(NSArray *challenges, NSError *error) {
        if (challenges) {
            self.challengesArray = challenges.mutableCopy;
        }
        [self.tableView reloadData];
    }];

    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:SBChallengeStatusNewNotification
                   object:nil
                   queue:[NSOperationQueue mainQueue]
                   usingBlock:^(NSNotification *note) {

                       if (self.challengesArray == nil) {
                           return;
                       }

                       SBChallenge * newChallenge = note.userInfo[SBChallengeObjectKey];
                       [self.challengesArray insertObject:newChallenge atIndex:0];
                       NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                       [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                   }];

    [self.observers addObject:observer];

    observer = [[NSNotificationCenter defaultCenter]
                addObserverForName:SBChallengeStatusDidChangeNotification
                object:nil
                queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note) {

                    if (self.challengesArray == nil) {
                        return;
                    }

                    SBChallenge * newChallenge = note.userInfo[SBChallengeObjectKey];
                    SBChallenge * oldChallenge = self.challengeDictionary[newChallenge.identifier];

                    NSInteger indexOfChallenge = [self.challengesArray indexOfObject:oldChallenge];
                    [self.challengesArray replaceObjectAtIndex:indexOfChallenge withObject:newChallenge];

                    NSIndexPath * indexPathOfChallenge = [NSIndexPath indexPathForRow:indexOfChallenge inSection:0];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPathOfChallenge]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                }];
    [self.observers addObject:observer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    self.challengesArray = nil;
    for (id observer in self.observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }

    self.observers = nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JDPCHallengeListViewController

-(void)pushViewControllerForChallenge:(SBChallenge *)challenge{
    JDPChallengeStatusViewController * statusViewController = [[JDPChallengeStatusViewController alloc] init];
    statusViewController.challenge = challenge;
    statusViewController.delegate = self;
    [self.navigationController pushViewController:statusViewController animated:YES];
}

#pragma mark - target action

-(void)doneButtonTapped:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.challengesArray.count >= 1) {
        return self.challengesArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (self.challengesArray == nil) {
        UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kJDPLoadingCellReuseIdentifier
                                                                      forIndexPath:indexPath];
        return cell;
    }
    
    if (self.challengesArray.count == 0) {
        UITableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kJDPNoChallegesCellReuseIdentifier forIndexPath:indexPath];
        return cell;
    }
    
    JDPChallengeCell * cell = [self.tableView dequeueReusableCellWithIdentifier:kJDPChallengeCellReuseIdentifier
                                                                   forIndexPath:indexPath];
    
    SBChallenge * challenge = self.challengesArray[indexPath.row];


    cell.challengerLabel.text = challenge.challenger.nickname;
    if (challenge.challengedPlayer) {
        cell.challengedPlayerLabel.text = challenge.challengedPlayer.nickname;
    }
    else{
        cell.challengedPlayerLabel.text = NSLocalizedString(@"Open Challenge", nil);
    }
    cell.amountLabel.text = [NSString stringWithFormat:@"£%@", challenge.amountInGBP];
    cell.statusLabel.text = challenge.status;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.challengesArray.count == 0) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    SBChallenge * challenge = self.challengesArray[indexPath.row];

    if (challenge.canSubmitScore){
        [self.delegate controller:self didSeletChallengeToPlay:challenge];
    }
    else{
        [self pushViewControllerForChallenge:challenge];
    }
}

#pragma mark - JDPChallengeListDelegate

-(void)controller:(UIViewController *)controller didSeletChallengeToPlay:(SBChallenge *)challenge{
    [self.delegate controller:self didSeletChallengeToPlay:challenge];
}

@end
