//
//  SBChallengeRequest.h
//  SmallBet
//
//  Created by Joel Parsons on 21/03/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SBPlayer;

/**
 This class is used to create a challenge. It acts as a container for the aspects of a challenge you can control. When filled in and passed to SBChallenge's challengeWithRequest:completion: method it will facilitate the registration of a challenge to your configuration.
 */

@interface SBChallengeRequest : NSObject
/** the amount the user wishes to bet in this challenge
@discussion If you dont supply this the server will return an error when you attempt to create a challenge with this challengeRequest
 The string should be of the format: 1.20 without the currency symbol
 */
@property (nonatomic, strong) NSString * amountInGBP;
/**
 an arbitrary NSData object containing state for your game. We take care of storing this data. It will be available in all instances of this challenge for both players so you can set up both clients to have the same challenge environment, select a game or scoring mode and even attach a shared challenge message. Size limit of 64kb. Please see the documentation on SBChallenge for more information on how you can use this property
 */
@property (nonatomic, copy) NSData * gameConfiguration;
/**
 The player who the user wishes to challenge. Ususally this object will be the result from a SBPlayerPickerViewController.
 */
@property (nonatomic, strong) SBPlayer * challengedPlayer;

@end

