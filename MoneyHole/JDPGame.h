//
//  JDPGame.h
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDPGame : NSObject

+(instancetype)randomGame;
-(id)initWithRandomTarget;

-(id)initWithGameData:(NSData *)gameData;
@property (nonatomic, strong, readonly) NSData * gameData;

@property (nonatomic, strong, readonly) NSString * moneyholeTargetPercentageString;

//this property is KVO compiant
@property (nonatomic, readonly) double moneyholeScorePercentage;
@property (nonatomic, strong, readonly) NSString * moneyholeScorePercentageString;

@property (nonatomic, readonly) NSInteger smallbetScore;

-(void)startFilling;
-(void)stopFilling;
@end
