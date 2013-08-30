//
//  JDPChallengeListViewController.h
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JDPChallengeSelectionDelegate.h"

/*


This class is an example of how to implement the list of challenges using the small bet SDK. 


You dont need to implement these screens in your app. You can use the SBChallengeListViewController (which was actually mostly based off this code)

This remains in the Moneyhole code as a demo to some of the interface customization you can achieve with the small-bet SDK.

 
 
 
 */
@interface JDPChallengeListViewController : UITableViewController
<JDPChallengeSelectionDelegate>

@property (nonatomic, weak) id <JDPChallengeSelectionDelegate> delegate;
-(void)pushViewControllerForChallenge:(SBChallenge *)challenge;
@end
