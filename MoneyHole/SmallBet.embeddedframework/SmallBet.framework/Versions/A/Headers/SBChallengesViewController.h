//
//  SBChallengesViewController.h
//  SmallBet
//
//  Created by Joel Parsons on 26/07/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBControllerDelegate.h"
@class SBChallenge;

@interface SBChallengesViewController : UIViewController

/**
 this controller expects its delegate to handle dismissal.
 
 @discussion If a user selects a challenge to play, you will recieve SBControllerResultTypeSuccess and get sent the challenge object as the object parameter to the delegate message.
 
 All other times the the object will be nil and the result will be SBControllerResultTypeCanceled
 */
@property (nonatomic, weak) id <SBControllerDelegate> delegate;
/**
 Only show the challenges which can have action taken on them (i.e. are playable)
 @discussion You need to set this before you display the view controller.
 */
@property (nonatomic) BOOL onlyShowActionableChallenges;
/**
 Makes the controller jump straight to the detail view for the challenge
 @discussion Handy for when you want to show the detail of a challenge that just changed status
 @param challenge The challenge to view the details of.
 */
-(void)showDetailForChallenge:(SBChallenge *)challenge;
@end
