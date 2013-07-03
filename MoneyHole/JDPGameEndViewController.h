//
//  JDPGameEndViewController.h
//  MoneyHole
//
//  Created by Joel Parsons on 30/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBChallenge;
@class JDPGame;

@interface JDPGameEndViewController : UIViewController

@property (nonatomic, strong) JDPGame * game;
@property (nonatomic, strong) SBChallenge * challenge;

@end
