//
//  SBSmallBetError.h
//  SmallBet
//
//  Created by Joel Parsons on 03/03/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>

/// The error domain for errors originating in the smallbet SKD or API
extern NSString * const SBErrorDomain;

typedef NS_ENUM(NSInteger, SBErrorCode){
    SBErrorUnknown,
    SBServerError,
    SBErrorInvalidAppKey,   //app key invalid
    SBErrorInvalidPlayerCredentials, //player needs to log in again
    SBErrorPlayerUnactivated, //player needs to visit the smallbet website and confirm their email
    SBErrorMissingInformation,
    SBErrorPaymentAlreadyActive,
    SBErrorAccessDenied,
    SBErrorActionNotAvailable, //This action is not or is no longer available
    /*
     CHALLENGE ERRORS
     */
    SBErrorInvalidChallengeRequest,
    SBErrorSizeTooLarge,    //when setting a too large payload on SBChallengeRequest
    SBErrorInvalidChallengeIdentifier,
    SBErrorInvalidScore
};

extern NSString * const SBAPIFailureReasonsErrorKey;

