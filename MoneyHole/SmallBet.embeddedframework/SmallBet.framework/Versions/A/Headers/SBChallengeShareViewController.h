//
//  SBChallengeShareViewController.h
//  SmallBet
//
//  Created by Joel Parsons on 26/03/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBControllerDelegate.h"

@class SBChallenge;
@interface SBChallengeShareViewController : UIViewController

/**
 designated initializer
 @param challenge The challenge you wish to share
 @returns an instance of the challenge share view controller configured to share the challenge passed in.
 */
-(id)initWithChallenge:(SBChallenge *)challenge;

/**
 The delegate for this view controller
 @discussion the delegate is responsible for dismissing the view controller. You will get:
 - SBControllerResultTypeSuccess if the player shared the challenge in one or more ways
 - SBControllerResultTypeCanceled if the player decided not to bother
 
 this class doesnt send an error or and object with any delegate calls.
 */
@property (nonatomic, weak) id<SBControllerDelegate> delegate;

@end


