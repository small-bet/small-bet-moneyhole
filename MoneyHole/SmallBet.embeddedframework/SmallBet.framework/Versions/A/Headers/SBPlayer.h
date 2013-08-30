//
//  SBPlayer.h
//  SmallBet
//
//  Created by Joel Parsons on 27/02/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This class represents a player on small bet. 
 
 You never create a player object. They are created for you by the SDK. Player objects can be retained by you for purposes of display or use in other SDK methods.
 
 All the properties of the player object are read only. They are not guaranteed to be filled in. When not filled in the properties will be nil. Not all players have all details. For example, some SDK methods may return player objects with data filled in, but some players may not have a twitterUsername. Always test before presenting any properties to the end user in an interface.
 */

@interface SBPlayer : NSObject
/// the player's smallbet nickname (player name, gamertag, handle, etc)
@property (nonatomic, copy, readonly) NSString * nickname;
/// the email address for the player (for privacy reasons this is rarely filled in)
@property (nonatomic, copy, readonly) NSString * emailAddress;
/// the phone number for the player
@property (nonatomic, copy, readonly) NSString * phoneNumber;
/// the players name on twitter
@property (nonatomic, copy, readonly) NSString * twitterUsername;
/// the ISO 3166-1 two letter country code, in caps.
@property (nonatomic, copy, readonly) NSString * country;

@end
