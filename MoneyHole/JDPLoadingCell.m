//
//  JDPLoadingCell.m
//  MoneyHole
//
//  Created by Joel Parsons on 31/05/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPLoadingCell.h"

@implementation JDPLoadingCell

-(void)prepareForReuse{
    [self.activitySpinner startAnimating];
}

@end
