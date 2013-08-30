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

@property (nonatomic, weak) id <SBControllerDelegate> delegate;

-(void)showDetailForChallenge:(SBChallenge *)challenge;
@end
