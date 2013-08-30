//
//  SBSmallbetManager.h
//  SmallBet
//
//  Created by Joel Parsons on 27/02/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBPlayer, SBPushNotificationManager;

@interface SBSmallbetManager : NSObject

/** @name Getting the small bet manager */

/**
 The smallbet manager isnt a strict singleton, but it is best to use the one provided by this method as it will be the one with your app keys stored. Its also the manager used by all the other small-bet classes.
 @returns common small bet manager
 */
+(instancetype)defaultManager;

/** @name Managing App Keys */
/**
 String containing the correct App key for either production or development environemnt.
 */
@property (nonatomic, readonly) NSString * appKey;

/**
 This method should be called in application:didFinishLaunchingWithOptions: by your application to set the app keys for both envoironments.
 
 @param sandboxKey the sandbox key from smallbet
 @param productionKey the production key from smallbet. This value is optional as you might not have one yet. Pass nil if you dont have a production key.
 */
-(void)setSandboxKey:(NSString *)sandboxKey andProductionKey:(NSString *)productionKey;


/** @name Login and logout */
/**
 The currently logged in player.
 @discussion This player object will always have the player nickname filled in, so you can greet your player. 
 
 This object is designed to indicate whether a player is logged in at all and it is stored here for methods that require the current player
 
 You can not log the player in yourself. You must present the SBLoginViewController to log the user in.
 */
@property (nonatomic, strong, readonly) SBPlayer * currentPlayer;


///logs out the current player. Sets currentPlayer to nil
-(void)logoutCurrentPlayer;

/** @name Getting Notified when challenges update */

/**
 switch to turn on and off the polling of the API for updates to the currentPlayer s challenges. defaults to YES;
 @discussion Polling occurs at an interval we define on a background thread. IF a change is detected to a challenge then notifications will be sent using the NSNotificationCenter to tell you about it. this allows you to watch for challenges changing and refresh your user interfaces as needed.
 */
@property (nonatomic) BOOL shouldPollAPIForChallengeUpdates;

/** @name Handling app launch with smallbet URLs */

/**
 Asks the Small Bet Manager to open a resource identified by a URL
 @param application The Application Object
 @param url A object representing a URL (Universal Resource Locator).
 @param sourceApplication The bundle ID of the application that is requesting your application to open the URL (url).
 @param annotation A property-list object supplied by the source application to communicate information to the receiving application.
 
 @returns YES if the Small Bet Manager successfully handled the request; NO if the attempt to open the URL resource failed. If the smallbet manager returns NO you should do your best to handle the opening of the URL (as its probably yours!)
 
 @discussion This method is provided to support launching of your app via URLs from smallbet. You gave us a URL scheme for your app when you registered it. User activity on the small bet website may result in the user launching your app directly using that URL scheme. In those cases the small bet service will attempt to pass your application more information about what the user was doing on small bet to help make the transition seamless.
 
 Call this method from the same method in your app delegate to give the SBSmallbetManager a chance to handle the smallbet URL. IF the url is from smallbet the SBSmallbetManager will post NSNotifications about their content using Smallbet SDK objects. Listen out for these notifications to react to app launches from smallbet URLs gracefully.
 */
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

/** @name Push Notifications */

/**
 The notification manager for managing push notificaitons. This is an API in progress and currently does nothing.
 */
@property (nonatomic, strong, readonly) SBPushNotificationManager * pushNotificationManager;

@end

/** @name Notifications */
/** When monitoring challenge status changes this notification is posted when the SDK detects a new challenge. You can use this notification to display a message to the user, or take the user directly to the appropriate challenge screen.

 @discussion
 The sender of the notification will be an instance of NSString containing the pertinent challenge identifier.
 This way you can listen to notifications regarding a challenge you may be displaying easily and then you can update that challenge in place. As the string wont be identical to your current challenge you will need to string match in your notification processing method
 */
extern NSString * const SBChallengeStatusNewNotification;
/** When monitoring challenge status changes this notification is posted when the SDK detects the state of a challenge has changed. You can use this notification to display a message to the user, or take the user directly to the appropriate challenge screen.
 
 @discussion
 The sender of the notification will be an instance of NSString containing the pertinent challenge identifier.
 This way you can listen to notifications regarding a challenge you may be displaying easily and then you can update that challenge in place. As the string wont be identical to your current challenge you will need to string match in your notification processing method
 */
extern NSString * const SBChallengeStatusDidChangeNotification;

/** Posted when Your app is launched from the small bet website or other places using your application URL schema and involved a challenge. 
 
 @discussion
 The sender of the notification will be an instance of NSString containing the pertinent challenge identifier.
 If you recieve this challenge notification it may be a good time to show the user the details of the challenge if it makes sense in your applications context.
 */
extern NSString * const SBApplicationDidOpenChallengeURLNotification;

/** Posted when the user is logged out in the background
 @discussion 
 The SDK talks to the API in the background to provide certain SDK features. If, during these messages, the SDK finds the users access token is no longer
 valid then this notification will be posted. Attempting to make SDK calls after this point will result in errors that the user is not logged in. Its good to
 listen to this notification so you can tell the user when they are logged out and why.
 
 In the user info dictionary is the error generated by the call the SDK made. It contains information for the user on the reason they were logged out for you to display to the User.
 */
extern NSString * const SBUserDidGetLoggedOutNotification;

/** @name Constants */

/**
 When recieving challenge status changes the relavent SBChallenge object will be stored in the userinfo dictionary under this key. 
 */
extern NSString * const SBChallengeObjectKey;

