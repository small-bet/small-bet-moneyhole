//
//  SBHypermediaObject.h
//  SmallBet
//
//  Created by Joel Parsons on 26/06/2013.
//  Copyright (c) 2013 Small-Bet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_OPTIONS(NSUInteger, SBHypermediaMethod){
    SBHypermediaMethodDefault   = 0,    //SBHypermediaMethodGET or as specified by action.
    SBHypermediaMethodGET       = 1 << 0,
    SBHypermediaMethodPOST      = 1 << 1,
    SBHypermediaMethodPUT       = 1 << 2,
    SBHypermediaMethodDELETE    = 1 << 3
};

@interface SBHypermediaObject : NSObject
+(NSArray *)objectsWithHypermediaResponse:(NSArray *)array;

+(instancetype)objectWithDictionary:(NSDictionary *)dictionary;
///designated initializer
-(instancetype)initWithDictionary:(NSDictionary *)otherDictionary;

/** @name backing storage */
-(id)objectForKey:(id)key;
-(id)objectForKeyedSubscript:(id)keyedSubscript;

/** @name Hypermedia Actions */
-(BOOL)canPerformAction:(NSString *)action;
-(SBHypermediaMethod)availableMethodsForAction:(NSString *)action;

-(void)performAction:(NSString *)action
      withCompletion:(void (^)(id result, NSError * error))completion;

-(void)performAction:(NSString *)action
      withParameters:(NSDictionary *)parameters
          completion:(void (^)(id result, NSError * error))completion;

-(void)performAction:(NSString *)action
          withMethod:(SBHypermediaMethod)method
          completion:(void (^)(id result, NSError * error))completion;

-(void)performAction:(NSString *)action
          withMethod:(SBHypermediaMethod)method
          parameters:(NSDictionary *)parameters
          completion:(void (^)(id result, NSError * error))completion;
@end
