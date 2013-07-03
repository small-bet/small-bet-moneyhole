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
#import "JDPChallengeListViewController.h"
#import "JDPCreateChallengeViewController.h"
#import "JDPCreditsViewController.h"
//models
#import "JDPGame.h"
#import "UIButton+theme.h"
//protocols
#import "JDPChallengeSelectionDelegate.h"

@interface JDPMenuViewController ()
<SBControllerDelegate, JDPChallengeSelectionDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *practiseButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *challengeFriendButton;
@property (weak, nonatomic) IBOutlet UIButton *challengeListButton;

@property (nonatomic, strong) SBChallenge * observedChallenge;

@property (nonatomic, strong) NSMutableArray * observers;
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
    
    NSArray * buttons = @[self.practiseButton, self.loginButton, self.logoutButton, self.challengeFriendButton, self.challengeListButton];
    
    
    for (UIButton * button in buttons) {
        [button jdpThemeButtonWithMoneyholeTheme];
    }
    
    [self configureInterface];
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

    observer = [[NSNotificationCenter defaultCenter]
                addObserverForName:SBUserDidGetLoggedOutNotification
                object:nil
                queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note) {
                    [self configureInterface];
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
    JDPChallengeListViewController * challengeListViewController = [[JDPChallengeListViewController alloc] init];
    challengeListViewController.delegate = self;

    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:challengeListViewController];

    NSString * imageFile = [[NSBundle mainBundle] pathForResource:@"background_dark" ofType:@"jpg"];
    UIImage * backgroundImage = [UIImage imageWithContentsOfFile:imageFile];
    UIImageView * backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundImageView.contentMode = UIViewContentModeBottom;
    backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    CGRect backgroundImageFrame = navigationController.view.bounds;
    // account for the height of the status bar
    backgroundImageFrame = CGRectApplyAffineTransform(backgroundImageFrame, CGAffineTransformMakeTranslation(0, 20.0f));
    backgroundImageFrame.size.height = CGRectGetHeight(backgroundImageFrame) - 20.0f;
    backgroundImageView.frame = backgroundImageFrame;
    backgroundImageView.clipsToBounds = YES;
    [navigationController.view insertSubview:backgroundImageView atIndex:0];

    if (challenge) {
        [challengeListViewController pushViewControllerForChallenge:challenge];
    }

    [self presentViewController:navigationController
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
    SBLoginViewController * loginViewController = [[SBLoginViewController alloc] initWithDelegate:self];
    [self presentViewController:loginViewController
                       animated:YES
                     completion:^{
                         
                     }];
}

- (IBAction)didTapLogoutButton:(id)sender {
    [[SBSmallbetManager defaultManager] logoutCurrentPlayer];
    [self configureInterface];
}

- (IBAction)didTapChallengeFriendButton:(id)sender{
    JDPCreateChallengeViewController * createChallengeController = [[JDPCreateChallengeViewController alloc] init];
    if ([self.parentViewController respondsToSelector:@selector(crossfadeToViewController:)]) {
        [(id)self.parentViewController crossfadeToViewController:createChallengeController];
    }
}

- (IBAction)didTapChallengeListButton:(id)sender {
    [self showChallengeListWithChallenge:nil];
}

#pragma mark - instance methods

-(void)configureInterface{
    //if we have a logged in player then enable the play buttons
    //and show the logout button.
    
    if ([[SBSmallbetManager defaultManager] currentPlayer]) {
        self.logoutButton.hidden = NO;
        self.loginButton.hidden = YES;
        self.challengeFriendButton.enabled = YES;
        self.challengeListButton.enabled = YES;
    }
    else{
        self.logoutButton.hidden = YES;
        self.loginButton.hidden = NO;
        self.challengeFriendButton.enabled = NO;
        self.challengeListButton.enabled = NO;
    }
}


#pragma mark - SBControllerDelegate

-(void)SBViewController:(UIViewController *)controller didFinishWithResult:(SBControllerResultType)result object:(id)object error:(NSError *)error{
    switch (result) {
        case SBControllerResultTypeSuccess:
            [self configureInterface];
            break;
        case SBControllerResultTypeCanceled:
        case SBControllerResultTypeFailed:
        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark - JDPChallengeListDelegate

-(void)controller:(JDPChallengeListViewController *)controller didSeletChallengeToPlay:(SBChallenge *)challenge{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 JDPGameViewController * gameViewController = [[JDPGameViewController alloc] init];
                                 gameViewController.challenge = challenge;
                                 [(id)self.parentViewController crossfadeToViewController:gameViewController];
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
