//
//  JDPChallengeStatusViewController.h
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDPChallengeSelectionDelegate.h"
@class SBChallenge;
@interface JDPChallengeStatusViewController : UIViewController
@property (nonatomic, weak) id <JDPChallengeSelectionDelegate> delegate;
@property (nonatomic, strong) SBChallenge * challenge;
@end
