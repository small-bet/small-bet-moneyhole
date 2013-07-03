//
//  JDPChallengeSelectionDelegate.h
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SBChallenge;

@protocol JDPChallengeSelectionDelegate <NSObject>
-(void)controller:(UIViewController *)controller didSeletChallengeToPlay:(SBChallenge *)challenge;
@end
