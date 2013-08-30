//
//  SBControllerDelegate.h
//  SmallBet
//
//  Created by Joel Parsons on 15/05/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SBControllerResultType){
    SBControllerResultTypeSuccess,  //For when the action completes successfully
    SBControllerResultTypeCanceled, //for when the user cancels the action
    SBControllerResultTypeFailed    //For when the action fails
};

@protocol SBControllerDelegate <NSObject>

@required
/**
 This is the one delegate method for controllers in the Small-Bet SDK.
 @param controller The controller sending the delegate message
 @param result an enum value telling you whether the controller's task was accomplished
 @param object an optional object sent to you by the controller.
 @param error If there was an error you can react to the controller will pass an error object here.
 
 @discussion Our view controllers always need you to dismiss them. This allows you to present them, or to add them as child view controllers with custom transitions. This single delegate method allows greater code reuse and avoids littering your classes with delegate methods.
 The parameters for object and error will be described in detail in the documentation for delegates that need to conform to this protocol
 */
-(void)SBViewController:(UIViewController *)controller didFinishWithResult:(SBControllerResultType)result object:(id)object error:(NSError *)error;

@end
