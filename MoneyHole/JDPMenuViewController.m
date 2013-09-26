//
//  JDPMenuViewController.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//
//frameworks
#import <SmallBet/SmallBet.h>
//this class's header
#import "JDPMenuViewController.h"
//controllers
#import "JDPMainViewController.h"
#import "JDPGameViewController.h"
#import "JDPCreateChallengeViewController.h"
#import "JDPCreditsViewController.h"
//models
#import "JDPGame.h"
//protocols

@interface JDPMenuViewController ()
<SBControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *practiseButton;
@property (weak, nonatomic) IBOutlet UIButton *accountButton;
@property (weak, nonatomic) IBOutlet UIButton *challengeFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *challengeListButton;

@property (nonatomic, strong) SBChallenge * observedChallenge;

@property (nonatomic, strong) NSMutableArray * observers;

@property (nonatomic) BOOL userIntendedToViewChallenges;
@end

@implementation JDPMenuViewController

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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor clearColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:SBChallengeStatusNewNotification
                   object:nil
                   queue:[NSOperationQueue mainQueue]
                   usingBlock:^(NSNotification *note) {
                       if (self.observedChallenge) {
                           return ;
                       }
                       SBChallenge * observedChallenge = note.userInfo[SBChallengeObjectKey];
                       self.observedChallenge = observedChallenge;
                       UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"New Challenge", @"alert title")
                                                                            message:NSLocalizedString(@"You have been challenged to a game of Moneyhole!", nil)
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"Later", @"alert button view challenge later")
                                                                  otherButtonTitles:NSLocalizedString(@"View", @"alert button view challenge now"), nil];
                       [alertView show];
                   }];
    [self.observers addObject:observer];

    observer = [[NSNotificationCenter defaultCenter]
                addObserverForName:SBChallengeStatusDidChangeNotification
                object:nil
                queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note) {
                    if (self.observedChallenge) {
                        return ;
                    }
                    SBChallenge * observedChallenge = note.userInfo[SBChallengeObjectKey];
                    self.observedChallenge = observedChallenge;
                    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Challenge Updated", @"alert title")
                                                                         message:NSLocalizedString(@"One of your challenges has been updated!", nil)
                                                                        delegate:self
                                                              cancelButtonTitle:NSLocalizedString(@"Later", @"alert button view challenge later")
                                                               otherButtonTitles:NSLocalizedString(@"View", @"alert button view challenge now"), nil];
                    [alertView show];
                }];

    [self.observers addObject:observer];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    for (id observer in self.observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JDPMenuViewController

- (void)showChallengeListWithChallenge:(SBChallenge *)challenge {
    SBChallengesViewController * challengeListViewController = [[SBChallengesViewController alloc] init];
    challengeListViewController.delegate = self;

    if (challenge) {
        [challengeListViewController showDetailForChallenge:challenge];
    }

    [self presentViewController:challengeListViewController
                       animated:YES
                     completion:^{

                     }];
}

#pragma mark - target action

- (IBAction)creditsButtonTapped:(id)sender {
    JDPCreditsViewController * creditsViewController = [[JDPCreditsViewController alloc] init];
    [(id)self.parentViewController crossfadeToViewController:creditsViewController];
}

- (IBAction)practiseButtonTapped:(id)sender {
    if ([self.parentViewController respondsToSelector:@selector(crossfadeToViewController:)]) {
        JDPGameViewController * gameViewController = [[JDPGameViewController alloc] init];
        gameViewController.game = [JDPGame randomGame];
        [(id)self.parentViewController crossfadeToViewController:gameViewController];
    }
}

- (IBAction)didTapLoginButton:(id)sender {
    SBLoginViewController * accountViewController = [[SBLoginViewController alloc] initWithDelegate:self];
    [self presentViewController:accountViewController
                       animated:YES
                     completion:^{
                         
                     }];
}

- (IBAction)didTapChallengeFriendButton:(id)sender{
    JDPCreateChallengeViewController * createChallengeController = [[JDPCreateChallengeViewController alloc] init];
    if ([self.parentViewController respondsToSelector:@selector(crossfadeToViewController:)]) {
        [(id)self.parentViewController crossfadeToViewController:createChallengeController];
    }
}

- (IBAction)didTapChallengeListButton:(id)sender {
    if ([[SBSmallbetManager defaultManager] currentPlayer] == nil) {
        self.userIntendedToViewChallenges = YES;
        SBLoginViewController * loginViewController = [[SBLoginViewController alloc] initWithDelegate:self];
        [self presentViewController:loginViewController
                           animated:YES
                         completion:^{
                             
                         }];
        return;
    }
    [self showChallengeListWithChallenge:nil];
}


#pragma mark - SBControllerDelegate

-(void)SBViewController:(UIViewController *)controller didFinishWithResult:(SBControllerResultType)result object:(id)object error:(NSError *)error{
    //This is the delegate method for all the smallbet controllers
    //we can detect which one we are talking about by class
    [self dismissViewControllerAnimated:YES completion:^{
        if ([controller isKindOfClass:[SBLoginViewController class]]) {
            switch (result) {
                case SBControllerResultTypeSuccess:
                    if (self.userIntendedToViewChallenges) {
                        [self showChallengeListWithChallenge:nil];
                    }
                    self.userIntendedToViewChallenges = NO;
                    break;
                case SBControllerResultTypeCanceled:
                case SBControllerResultTypeFailed:
                default:
                    break;
            }
        }
        if ([controller isKindOfClass:[SBChallengesViewController class]]) {
            switch (result) {
                case SBControllerResultTypeSuccess:{
                    //when selecting challenges if the result is success then the object
                    //is the SBChallenge the user has selected to play right now!!
                    JDPGameViewController * gameViewController = [[JDPGameViewController alloc] init];
                    gameViewController.challenge = object;
                    [(id)self.parentViewController crossfadeToViewController:gameViewController];
                }
                    break;
                case SBControllerResultTypeCanceled:
                case SBControllerResultTypeFailed:
                default:
                    break;
            }
        }
    }];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == alertView.firstOtherButtonIndex) {
        [self showChallengeListWithChallenge:self.observedChallenge];
    }
    self.observedChallenge = nil;
}

@end
