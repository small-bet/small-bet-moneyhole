//
//  SBOnboardingViewController.h
//  SmallBet
//
//  Created by Dan Hopwood on 09/09/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SBControllerDelegate.h"

@interface SBOnboardingViewController : UIViewController

/**
 The delegate for this view controller
 @discussion the delegate is responsible for dismissing the view controller. You will get:
 - SBControllerResultTypeSuccess if the player makes it to the final screen
 - SBControllerResultTypeCanceled is the player wishes to dismiss the screen early
 
 this class doesnt send an error or any object with any delegate calls.
 */
@property (nonatomic, weak) id<SBControllerDelegate> delegate;

/**
 designated initializer
 @param delegate an object which confroms to the SBControllerDelegate protocol which can act as the delegate for this view controller
 @returns an instance of this controller ready to go!
 */
-(id)initWithDelegate:(id<SBControllerDelegate>)delegate;

@end
