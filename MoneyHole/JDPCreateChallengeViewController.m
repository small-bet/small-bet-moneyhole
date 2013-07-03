//
//  JDPCreateChallengeViewController.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPCreateChallengeViewController.h"
#import <SmallBet/SmallBet.h>

#import "JDPMainViewController.h"
#import "JDPMenuViewController.h"

#import "JDPGame.h"
#import "AFNetworking.h"

#import "UIButton+theme.h"

@interface JDPCreateChallengeViewController ()
<SBControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *friendLabel;
@property (weak, nonatomic) IBOutlet SBChallengeAmountSlider *challengeSlider;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *pickFriendButton;

@property (nonatomic, strong) SBPlayer * pickedPlayer;
@property (nonatomic, strong) SBChallenge * createdChallenge;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonsToTheme;

@end

@implementation JDPCreateChallengeViewController

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
    self.friendLabel.text = NSLocalizedString(@"Open Challenge", nil);
    
    for (UIButton * button in self.buttonsToTheme) {
        [button jdpThemeButtonWithMoneyholeTheme];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - JDPCreateChallengeViewController

- (void)returnToMenuViewController {
    JDPMenuViewController * menuViewController = [[JDPMenuViewController alloc] init];
    
    if ([self.parentViewController respondsToSelector:@selector(crossfadeToViewController:)]) {
        [(id)self.parentViewController crossfadeToViewController:menuViewController];
    }
}

#pragma mark - target action

- (IBAction)cancelButtonTapped:(id)sender {
    
    [self returnToMenuViewController];
}

- (IBAction)pickFriendButtonTapped:(id)sender {
    SBPlayerPickerViewController * playerPickerViewController = [[SBPlayerPickerViewController alloc] init];
    playerPickerViewController.definesPresentationContext = YES;
    playerPickerViewController.delegate = self;
    [self presentViewController:playerPickerViewController
                       animated:YES
                     completion:^{
                         
                     }];
}

- (IBAction)challengeButtonTapped:(UIButton *)sender {
    sender.enabled = NO;
    self.pickFriendButton.enabled = NO;
    self.cancelButton.enabled = NO;
    
    SBChallengeRequest * challengeRequest = [[SBChallengeRequest alloc] init];
    challengeRequest.challengedPlayer = self.pickedPlayer;
    
    JDPGame * game = [JDPGame randomGame];
    challengeRequest.gameConfiguration = game.gameData;
    
    challengeRequest.amountInGBP = self.challengeSlider.amountInGBP;
    
    [SBChallenge challengeWithRequest:challengeRequest completion:^(SBChallenge *challenge, NSError *error) {
        UIAlertView * alert = nil;
        if (challenge) {
            self.createdChallenge = challenge;
            SBChallengeShareViewController * shareViewController = [[SBChallengeShareViewController alloc] initWithChallenge:self.createdChallenge];
            shareViewController.delegate = self;
            [self presentViewController:shareViewController
                               animated:YES
                             completion:^{

                             }];
        }
        else if ([error.domain isEqualToString:AFNetworkingErrorDomain]) {
            alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Error", nil)
                                               message:error.localizedDescription
                                              delegate:nil
                                     cancelButtonTitle:NSLocalizedString(@"Ah okay", nil)
                                     otherButtonTitles:nil];
        }
        else if ([error.domain isEqualToString:SBErrorDomain]) {
            
            switch (error.code) {
                case SBErrorInvalidPlayerCredentials:{
                    //the player has been logged out as their credentials are bad. Attempt to recover
                    NSString * messageString = [NSString stringWithFormat:NSLocalizedString(@"You have been logged out because %@", nil),[error localizedFailureReason]];
                    alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Could Not Create Challenge", nil)
                                                       message:messageString
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedString(@"Return to Menu", nil)
                                             otherButtonTitles:nil];
                }
                    break;
                case SBErrorSizeTooLarge:
                    //the payload was too large for the challenge
                    
                case SBErrorMissingInformation:
                    //the challenge request was not filled in properly
                    
                default:
                    break;
            }
        }
        [alert show];
        
        sender.enabled = YES;
        self.pickFriendButton.enabled = YES;
        self.cancelButton.enabled = YES;
    }];
}

#pragma mark - SBControllerDelegate

-(void)SBViewController:(UIViewController *)controller didFinishWithResult:(SBControllerResultType)result object:(id)object error:(NSError *)error{
    if ([controller isKindOfClass:[SBPlayerPickerViewController class]]) {
        switch (result) {
            case SBControllerResultTypeSuccess:
                self.pickedPlayer = object;

                if (self.pickedPlayer.emailAddress) {
                    self.friendLabel.text = self.pickedPlayer.emailAddress;
                }
                else if (self.pickedPlayer.phoneNumber) {
                    self.friendLabel.text = self.pickedPlayer.phoneNumber;
                }
                break;
            case SBControllerResultTypeCanceled:
                self.pickedPlayer = nil;
                self.friendLabel.text = NSLocalizedString(@"Open Challenge", @"a challenge against anyone");
                break;
            case SBControllerResultTypeFailed:
            default:
                break;
        }
    }
    else if ([controller isKindOfClass:[SBChallengeShareViewController class]]){
        [self dismissViewControllerAnimated:YES
                                 completion:^{
                                     [self returnToMenuViewController];
                                 }];
        return;
    }

    [self dismissViewControllerAnimated:YES
                             completion:^{
                             }];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:NSLocalizedString(@"Could Not Create Challenge", nil)]) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            [self returnToMenuViewController];
        }
    }
}

@end
