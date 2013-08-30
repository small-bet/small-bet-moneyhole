//
//  SBSharingItem.h
//  SmallBet
//
//  Created by Joel Parsons on 17/05/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SBPlayer;
/**
 A sharing item. This class is designed to help with sharing challenges. Small-Bet use this class to feed information into the SBChallengeShareViewController about the challenge you are attempting to share.

 Each challenge has two of these instances by default. One will return A sharing URL and one will return a sharing string. Each sharing item will contain the same data but will return a different object. Check the UIActivityItemSource protocol methods for how to choose between them.

 The class conforms to UIActivityItemSource. You can feed these Items into a UIActivityViewController if you want and it will work!
 
 If you want to implement your own sharing interface you probably only need to grab one instance of this class from the SBChallenge. You can access the relelvant URLS and localized sharing strings to build your sharing messages that the user can put on their socail networks or message their friends.
 */
@interface SBSharingItem : NSObject
<UIActivityItemSource>

/**
 this is the challenged player object representing the challenged player on smallbet (if there is one, may be nil)
 @discussion If the challenge is newly created this object will contain the phone number / email address of the 
 person the player intended to challenge even if the challenge created is an open challenge. The idea is this will help you pre-fill who the sharing messages should be addressed to.
 
  @warning *Important:* do not use this property as a test for an open challenge. Check the challenge itself.
 */
@property (nonatomic, strong, readonly) SBPlayer * challengedPlayer;
/**
 a description of what the user is sharing
 */
@property (nonatomic, strong, readonly) NSString * descriptionString;
/**
 a descriptive string describing how the user downloads the app
 */
@property (nonatomic, strong, readonly) NSString * downloadAppActionString;

/**
 a desciptive string about what the user needs to do to see the challenge
 */
@property (nonatomic, strong, readonly) NSString * viewChallengeActionString;
/**
 A URL to this app in the apple app store
 */
@property (nonatomic, strong, readonly) NSURL * appStoreURL;
/**
 A URL to see this challenge on the web
 */
@property (nonatomic, strong, readonly) NSURL * challengeURL;
/**
 A URL to open this challenge in the other players app (assuming they have this app)
 */
@property (nonatomic, strong, readonly) NSURL * appSpecificURL;

@end
