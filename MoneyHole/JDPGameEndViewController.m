//
//  JDPGameEndViewController.m
//  MoneyHole
//
//  Created by Joel Parsons on 30/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPGameEndViewController.h"
#import <SmallBet/SmallBet.h>

#import "JDPMainViewController.h"
#import "JDPMenuViewController.h"

#import "JDPGame.h"

@interface JDPGameEndViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aimLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreSummaryView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moneyImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

@property (nonatomic) CGFloat maxMoneyViewHeight;
@end

@implementation JDPGameEndViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (self.challenge == nil) {
        [self.activityIndicator stopAnimating];
        self.doneButton.alpha = 1.0;
    }
    
    self.maxMoneyViewHeight = self.moneyImageView.frame.size.height;
    CGFloat moneyviewHeight = self.maxMoneyViewHeight * self.game.moneyholeScorePercentage;
    
    CGRect moneyViewFrame = self.moneyImageView.frame;
    moneyViewFrame.origin.y = CGRectGetHeight(self.view.bounds) - moneyviewHeight;
    moneyViewFrame.size.height = moneyviewHeight;
    
    self.moneyImageView.frame = moneyViewFrame;
    
    self.scoreLabel.text = self.game.moneyholeScorePercentageString;
    self.aimLabel.text = self.game.moneyholeTargetPercentageString;
    
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self submitScore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)submitScore{
    if (self.challenge) {
        [self.challenge submitScore:self.game.smallbetScore
                     withCompletion:^(SBChallenge *updtedChallenge, NSError *error) {
                         if (updtedChallenge) {
                             self.challenge = updtedChallenge;
                             [self.doneButton setTitle:NSLocalizedString(@"Score Submitted!", nil) forState:UIControlStateNormal];
                         }
                         else if (error.domain == SBErrorDomain && error.code == SBErrorActionNotAvailable){
                             self.challenge = nil;
                             self.errorMessageLabel.text = NSLocalizedString(@"This challenge has already been submitted", nil);
                             [UIView animateWithDuration:0.4
                                              animations:^{
                                                  self.scoreSummaryView.alpha = 0;
                                                  self.errorMessageLabel.alpha = 1.0;
                                              }];
                         }
                         else{
                             self.errorMessageLabel.text = error.localizedDescription;
                             [self.doneButton setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
                             [UIView animateWithDuration:0.4
                                              animations:^{
                                                  self.scoreSummaryView.alpha = 0;
                                                  self.errorMessageLabel.alpha = 1.0;
                                              }];
                         }
                         
                         [self.activityIndicator stopAnimating];
                         [UIView animateWithDuration:0.4
                                          animations:^{
                                              self.doneButton.alpha = 1.0;
                                          }];
                     }];
    }
}

#pragma mark - target action

- (IBAction)doneButtonTapped:(id)sender {
    
    if (self.challenge.canSubmitScore) {
        [self submitScore];
        return;
    }
    
    JDPMenuViewController * menuViewController = [[JDPMenuViewController alloc] init];
    if ([self.parentViewController respondsToSelector:@selector(crossfadeToViewController:)]) {
        [(id)self.parentViewController crossfadeToViewController:menuViewController];
    }
}

@end
