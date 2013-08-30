//
//  SBPlayerPickerViewController.h
//  SmallBet
//
//  Created by Joel Parsons on 15/03/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBControllerDelegate.h"

//forward declarations
@class SBPlayer;

/**
 This view controller uses the address book UI to create an SBPlayer instance which you can set as part of an SBChallengeRequest when making a challenge.
 
 It handles all the permissions stuff for you and returns you an SBPlayer obejct via the delegate protocol that you can just pop onto an SBChallengeRequest.
 
 Just instantiate this view controller and present it. Set yourself as the delegate to respond to events and then dismiss the controller yourself. 
 */

@interface SBPlayerPickerViewController : UIViewController
/**
 Set an object to recieve delegate messages. This object should be responsible for dismissal of the view controller.
 @discussion
 You get:
 - SBControllerResultTypeSuccess,  When the user selects a contact from their address book. The object paramater of the delegate message contains an SBPlayer object representing that contact.
 - SBControllerResultTypeCanceled, when the user cancels
 - SBControllerResultTypeFailed   When permission to read the address book is denied. We provide a screen to handle this and tell the user how to turn address book access back on for your app. We let you know what happened as a courtesy. the Error object of the delegate message will be in the SBError domain and the code will be SBErrorAccessDenied.
 */
@property (nonatomic, weak) id<SBControllerDelegate> delegate;

@end

