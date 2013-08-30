//
//  SBChallengeAmountSlider.h
//  SmallBet
//
//  Created by Joel Parsons on 02/04/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 This is a convenient view you can use to allow the player to select the amount they wish to challenge. It takes care of the formatting and gives you a convenient amountInGBP property that is formatted in the way that the SBChallengeRequest expects. Nice. Its also transparent so you can make it fit into your interface with little trouble. It can be made inserted into your interface from a nib or storyboard. Just drag in a view from the sidebar and set its class to SBChallengeAmountSlider. You can hook it up to your view controller as you might expect and then BOOM, when you run you have a fancy small-bet challenge amount slider.
 */
@interface SBChallengeAmountSlider : UIControl
/**
 The amount the slider has been set to.
 @discussion This string is conveniently formatted to fit right into a SBChallengeRequest
 */
@property (nonatomic, strong) NSString * amountInGBP;
/**
 an additional method to animate the transition to the new amount
 @param amountInGBP a string formatted like so: 1.20 without the currency symbol
 @param animated A flag which, when YES, animates the transition.
 */
-(void)setAmountInGBP:(NSString *)amountInGBP animated:(BOOL)animated;

@end
