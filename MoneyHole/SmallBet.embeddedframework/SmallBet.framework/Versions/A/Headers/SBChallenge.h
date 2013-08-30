//
//  SBChallenge.h
//  SmallBet
//
//  Created by Joel Parsons on 19/03/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBHypermediaObject.h"
/**
 The class representing a challenge on smallbet. 
 
 You never create a challenge object directly. They are made for you and returned by the SDK. You can then query them for information for display to the user and perform a limited set of functions. Challenge objects may need to be retained by you for use in further API calls.
 
 Challenge objects are immutable. The contents of a challenge object does not change. When you want to do something with a challenge, like accpet a challenge on behalf of a user, you get a replacement challenge object in response. If you had a list of challenges in a mutableArray you could replace the old challenge object with the new one.

 Similar to SBPlayer, not all properties are guaranteed to be filled in every time you recieve a challenge object. You should always test for the existance of a value before presenting any information from a challenge object to the user.
 */

@class SBPlayer, SBChallengeRequest, SBSharingItem;

@interface SBChallenge : SBHypermediaObject

/** @name getting challenge objects */

/**
 This method fetches the an array of all the users challenges.
 @param completion A completion block that returns nil and is run when the response from the API has been processed. It has two arguements: challenges, the array of SBChallenge objects returned from the server and error, the error that occurred (if any). Either challenges or error will be nil.

 @discussion The array of challenges is returned in date descending order. (IE newest challenges at the beginning) You can rely on this ordering.
 */
+(void)allChallengesWithCompletion:(void (^)(NSArray * challenges, NSError * error))completion;

/**
 This method is the method used to fetch individual challenge objects from the smallbet API.

 @param identifier the identifier of the challenge you want to fetch
 @param completion A completion block executed once the response has been recieved by the API. It has two arguements. The challenge object recieved and an error. One of the arguements will always be nil.

 @discussion If you want to persist challenge objects across launches it is best to store challenge identifiers and to fetch them as they are needed using this method. This ensures that challenge objects are always up to date with the objects stored on the server.
*/
+(void)challengewithIdentifier:(NSString *)identifier completion:(void (^) (SBChallenge * challenge, NSError * error))completion;

/**
 This is the method to register a new challenge with the smallbet API

 @param request a challenge request object suitably filled in
 @param completion a block which is exeuted on response by the API. It has two arguements. One of the arguements will always be nil.

 @discussion The challenge arguement in the block here is handy to keep around for placing in a SBChallengeShareViewController.

 The block may be called immeadiately if the gameConfiguration is over the 64KB size limit
 */
+(void)challengeWithRequest:(SBChallengeRequest *)request completion:(void (^) (SBChallenge * challenge, NSError *error))completion;

/** @name Properties */

/**
  the unique identifier small bet uses to identify this challenge
 
 you can store these identifiers and then recall individual challenges later if it would make sense to do so. Fetching the challenge fresh using the identifier is also the only way to find out if a challenge state is updated. The challenge objects are not modified once they are created.
 */
@property (nonatomic, copy, readonly) NSString * identifier;
/**
 the stake of the challenge in GBP.
 @discussion the string is a single decimal in the form 3.20 and does not contain the currency symbol
 */
@property (nonatomic, copy, readonly) NSString * amountInGBP;

/**
 The status of a challenge in a human readable, localized form. This string indicates to the user the current state of their challenge
 If it is in their list but has no actions that can be performed upon it, like accept, reject or score submission, this string will describe why.
 Reasons can range from "waiting for other player to accept" to "waiting for score from other player".
 @discussion you can use this in your App to communicate with the user what needs to be done to progress with the challenge. 
 */
@property (nonatomic, copy, readonly) NSString * status;
/**
 A player object with the details of the challenger. You can not compare this to the currentPlayer in the SBSmallBetManager to find out if they are the same player. It is up to the user to identify which party they are in a smallbet challenge.
 */
@property (nonatomic, strong, readonly) SBPlayer * challenger;
/**
 A player object with the details of the challenged player. You can not compare this to the currentPlayer in the SBSmallBetManager to find out if they are the same player. It is up to the user to identify which party they are in a smallbet challenge.
 
 This property will be nil if the challenge is an open challenge. In an open challenge the player is given a URL to share with their friends and the first user to visit the URL and claim the challenge becomes the challenged player.
 
 If there is no challenged player it is safe to assume that the currentPlayer is the challenger.
 */
@property (nonatomic, strong, readonly) SBPlayer * challengedPlayer;

/// the name of your app as registered on the small bet API
@property (nonatomic, copy, readonly) NSString * appName;
/**
 This property represents some arbitrary NSData that you can use to send information about the challenge level/mode/game state between instanced of your app to enable you to have fair, fun challenges.
 
 @discussion
 There is a size limit of 64KB on this property.
 
 Interesting ways you can use this property are:
 NSData * data = [NSKeyedArchiver archivedDataWithRootObject:gameState];
 
 --or--
 
 NSData * data = [NSPropertyListSerialisation 
                  dataWithPropertyList:gameStateDictionary 
                                format:NSPropertyListBinaryFormat_v1_0
                               options:0 
                                 error:&error];
 
 The property list serialisation is more space efficient than keyed archiving. Either way check your data.length to see what size it is before making an SBChallengeRequest
 
 */
@property (nonatomic, copy, readonly) NSData * gameConfiguration;

/** @name sharing a challenge */

/**
 This is the challenge sharing item. It is used to share information about the challenge.
 */
@property (nonatomic, strong, readonly) NSArray * sharingItems;

/**
 This method shares the challenge by email. The email is sent by smallbet servers.

 @discussion this option is only available on open challenges
 */
-(void)shareByEmailToAddress:(NSString *)emailAddress completion:(void (^)(NSError *error))completion;

/** @name Accepting and Rejecting a challenge */

/**
 property for determining whether the challenge is able to be accepted at this time.
 @discussion Use this property to determine which UI elements you should show for a challenge
 */
@property (nonatomic, readonly) BOOL canBeAccepted;
/** Property for determining if the challenge instance can be rejected at this time.
 @discussion Use this property to determine which UI elements you should show when displaying the details challenge object to your users
 This is a companion to canBeAccepted because if they challenge a random player they have the option to reject that challenge before they find out who the other player is. In this scenario reject is the only action available on the challenge.
*/
@property (nonatomic, readonly) BOOL canBeRejected;

/**
 method to accept a challenge.
 @param completion a completion block that returns nothing and takes a challenge and error arguement
 @discussion The block may be fired straight away if the canBeAccepted: is NO
 
 You may get the SBErrorActionNotAvailable error from the API if the action became
 unavailable in the time the object was fetched and the time the accept action was sent.
 In these cases the challenges available actions will update and you should update your UI
 as needed to handle the error.
 
 If this request completes successfully the challenge arguement of the block will contain a new challenge object to replace the old one with. 
 */
-(void)acceptedChallengeWithCompletion:(void (^) (SBChallenge* acceptedChallenge, NSError * error))completion;
/**
 method to reject a challenge.
 @param completion a completion block that returns nothing and takes an error arguement
 @discussion The block may be fired straight away if canBeRejected: is NO
 
 You may get the SBErrorActionNotAvailable error from the API if the action became
 unavailable in the time the object was fetched and the time the accept action was sent.
 In these cases the challenges available actions will update and you should update your UI
 as needed to handle the error.
 
  If this request completes successfully the challenge arguement of the block will contain a new challenge object to replace the old one with. 
 */
-(void)rejectedChallengeWithCompletion:(void (^) (SBChallenge* rejectedChallenge, NSError * error))completion;

/** @name Getting an updated challenge */

/**
 fetches the latest version of this challenge instance from the server
 @param completion completion a completion block that returns nothing and takes a challenge and error arguement
 @discussion This method is simply a convenience method for calling +challengeWithIdentifier:completion: with
 the identifier of this challenge instance. It is here for sake of clarity and providing an obvious way to
 get updated versions of your challenges.
 
 sometimes you will find your challenge object has gotten out of sync with the server, say if the user has gone away
 leaving a challenge on the screen and come back to your app later. Sometimes you may try to perform an action
 with a challenge such as accepting or rejecting a challenge and you may get a non network based error. In these cases you should
 get an updated challenge from the server

 If you are displaying the details of a challenge to a player when your app is suspended upon recieveing UIApplicationDidBecomeActiveNotification you should
 refresh your visible challenge with this method.
 */
-(void)updatedChallengeWithCompletion:(void (^) (SBChallenge * updatedChallenge, NSError * error))completion;

/** @name Submitting a score to a challenge */

/**
 Property for determining if the challenge will accept score submissions at this time.
 @discussion Use this property to determine what controls it is suitable to show for a challenge.
 */
@property (nonatomic, readonly) BOOL canSubmitScore;

/**
 Method to submit a score for a challenge. This method asynchronously submits a score for this challenge to the API.
 @param score The score the user attained in your game represented as an NSInteger.
 @param completion A block that is executed on completion. It returns nothing and takes two arguements, A new challenge object that replaces the old one and an error. One of the arguements will always be nil.
 @discussion It is reccommended you boil down any factors you use to score the player into one number which we then submit to the API. Once the score is submitted it is not accessible again at any point. 
 The small-bet API will decide the winner by picking the player with the highest score.
 If you want to indicate to a user how they did in a particular challenge it is best to store the original socring metrics in a dictionary with the challenge identifier as the key.
 */
-(void)submitScore:(NSInteger)score withCompletion:(void (^) (SBChallenge * updtedChallenge, NSError * error))completion;

@end
