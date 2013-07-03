//
//  JDPChallengeStatusViewController.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPChallengeStatusViewController.h"
#import <SmallBet/SmallBet.h>
#import "UIButton+theme.h"

@interface JDPChallengeStatusViewController ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengerLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengedPlayerLabel;

@property (weak, nonatomic) IBOutlet SBButton *acceptButton;
@property (weak, nonatomic) IBOutlet SBButton *rejectButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong) NSMutableArray * observers;
@end

@implementation JDPChallengeStatusViewController

#pragma mark - properties
-(NSMutableArray *)observers{
    if (_observers) {
        return _observers;
    }

    _observers = [NSMutableArray array];
    return _observers;
}
#pragma mark - lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Challenge", @"title of challenge screen");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.playButton jdpThemeButtonWithMoneyholeTheme];
    [self configureInterface];
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:SBChallengeStatusDidChangeNotification
                   object:nil
                   queue:[NSOperationQueue mainQueue]
                   usingBlock:^(NSNotification *note) {
                       if ([note.object isEqual:self.challenge.identifier]) {
                           self.challenge = note.userInfo[SBChallengeObjectKey];
                           [self configureInterface];
                       }
                   }];
    
    [self.observers addObject:observer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

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

-(void)configureInterface{
    
    self.acceptButton.hidden = self.challenge.canBeAccepted ? NO : YES;
    self.rejectButton.hidden = self.challenge.canBeRejected ? NO : YES;
    self.playButton.hidden = self.challenge.canSubmitScore ? NO : YES;
    
    self.amountLabel.text =  [NSString stringWithFormat:@"£%@", self.challenge.amountInGBP];
    self.statusLabel.text = self.challenge.status;
    self.challengerLabel.text = self.challenge.challenger.nickname;
    if (self.challenge.challengedPlayer) {
        self.challengedPlayerLabel.text = self.challenge.challengedPlayer.nickname;
    }
    else{
        self.challengedPlayerLabel.text = NSLocalizedString(@"Open Challenge", nil);
    }
}

#pragma mark - target action

- (IBAction)acceptButtonTapped:(id)sender {
    [self.challenge acceptedChallengeWithCompletion:^(SBChallenge *acceptedChallenge, NSError *error) {
        if (acceptedChallenge) {
            self.challenge = acceptedChallenge;
            [self configureInterface];
            return ;
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"There was a problem", nil)
                                                         message:error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                               otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)rejectButtonTapped:(id)sender {
    [self.challenge rejectedChallengeWithCompletion:^(SBChallenge *rejectedChallenge, NSError *error) {
        if (rejectedChallenge) {
            self.challenge = rejectedChallenge;
            [self configureInterface];
            return ;
        }
        
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"There was a problem", nil)
                                                         message:error.localizedDescription
                                                        delegate:nil
                                               cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                               otherButtonTitles:nil];
        [alert show];
    }];
}

- (IBAction)playButtonTapped:(id)sender {
    [self.delegate controller:self didSeletChallengeToPlay:self.challenge];
}

@end
