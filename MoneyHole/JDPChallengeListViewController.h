//
//  JDPChallengeListViewController.h
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDPChallengeSelectionDelegate.h"

@interface JDPChallengeListViewController : UITableViewController
<JDPChallengeSelectionDelegate>

@property (nonatomic, weak) id <JDPChallengeSelectionDelegate> delegate;
-(void)pushViewControllerForChallenge:(SBChallenge *)challenge;
@end
