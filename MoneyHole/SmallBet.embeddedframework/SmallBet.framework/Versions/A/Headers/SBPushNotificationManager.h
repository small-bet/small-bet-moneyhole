//
//  SBPushNotificationManager.h
//  SmallBet
//
//  Created by Joel Parsons on 17/06/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPushNotificationManager : NSObject
/**
 This class mirrors these app delegate methods and is designed to be called as a pass through from your app delegate when push notifications are finished. This is an API in progress.
 */
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
@end
