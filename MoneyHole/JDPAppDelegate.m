//
//  SBTAppDelegate.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPAppDelegate.h"
#import <SmallBet/SmallBet.h>

@implementation JDPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //this is all you need to do sto start using small-bet in your app.
    [[SBSmallbetManager defaultManager] setSandboxKey:<#small-bet sandbox key that you get from http://small-bet.com#> andProductionKey:nil];
        
    [self.window makeKeyAndVisible];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - URL handling
/**
 If you add this code here the smallbet SDK will let you know the challenge the user tapped on when we launch your app from a URL.
 You will recieve a SBApplicationDidOpenChallengeURLNotification
 from the NSNotificationCenter
 The sender of the notification will be an instance of NSString containing the pertinent challenge identifier.
 */
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[SBSmallbetManager defaultManager] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
