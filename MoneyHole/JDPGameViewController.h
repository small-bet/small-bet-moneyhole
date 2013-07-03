//
//  JDPGameViewController.h
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDPGame;
@class SBChallenge;

@interface JDPGameViewController : UIViewController

@property (nonatomic, strong) JDPGame * game;
@property (nonatomic, strong) SBChallenge * challenge;

@end
