//
//  SBButton.h
//  SmallBet
//
//  Created by Joel Parsons on 03/04/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 SBButton is an abstract button loading class with some pretty nifty features!
 
 You should never init a generic SBButton directly. You can use the convenience class method
 smallBetButtonWithType: to get the correct type of smallbet button made. There are no extra methods
 defined on these buttons. 
 
 The idea here is that you can use these buttons in code or in interface builder documents with little fuss.
 
 In code create a small bet challenge button like so:
 UIButton * button = [SBButton smallBetButtonWithType:SBButtonTypeChallenge];
 
 In interface builder all you have to do is drag a generic UIButton into your interface.
 You then set the class of that button to be an SBButton. Then you set the tag to be the value
 of the SBButtonType you are looking for
 
 To make a challenge button you would set the class of the button to SBButton and set the tag to 100.
 
 The button will be substituted at runtime with the smallbet branded button. It will keep
 all the targets and actions you set in interface builder as well as the button center. The small-bet
 buttons are all a set size of 298x51 points.
 
 All other cusomizations you make in interface builder will be lost.
 
 Small bet buttons have their tag property set to the value of their SBButtonType for easy
 detection of button type in code. 
 
 */

/**
 an enum of the types of button you can have vended from the small bet API
 */
typedef NS_ENUM(NSUInteger, SBButtonType){
    SBButtonTypeChallenge = 100,
    SBButtonTypeAcceptChallenge = 101,
    SBButtonTypeRejectChallenge = 102
};

@interface SBButton : UIButton
/**
 Method to instantiate the correct small bet button class using one of the defined SBButton Types
 
 @param buttonType One of the button types as defined in the SBButtonType enum
 @returns a branded small bet button of the desired type.
 */
+(instancetype)smallBetButtonWithType:(SBButtonType)buttonType;

@end
