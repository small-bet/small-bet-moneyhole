//
//  JDPChallengeCell.h
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDPChallengeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *challengerLabel;
@property (weak, nonatomic) IBOutlet UILabel *challengedPlayerLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
