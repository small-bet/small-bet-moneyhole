//
//  JDPGame.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPGame.h"

@interface JDPGame ()
@property (nonatomic) NSUInteger moneyholeTarget;
@property (nonatomic) NSUInteger moneyholeScore;

@property (nonatomic, weak) NSTimer * timer;
@end

#define MONEY_HOLE_MAX_SCORE 10000

@implementation JDPGame

#pragma mark - init

+(instancetype)randomGame{
    return [[JDPGame alloc] initWithRandomTarget];
}

-(id)initWithRandomTarget{
    self = [super init];
    if (self) {
        
        NSInteger scoreRange = MONEY_HOLE_MAX_SCORE - (MONEY_HOLE_MAX_SCORE / 10);
        NSInteger randomTarget = arc4random_uniform(scoreRange);
        
        _moneyholeTarget = randomTarget + (MONEY_HOLE_MAX_SCORE / 20);
    }
    
    return self;
}

-(id)initWithGameData:(NSData *)gameData{
    self = [super init];
    if (self) {
        NSError * error = nil;
        NSDictionary * gameDataDictionary =
        [NSPropertyListSerialization propertyListWithData:gameData
                                                  options:NSPropertyListImmutable
                                                   format:NULL
                                                    error:&error];
        _moneyholeTarget = [gameDataDictionary[@"target"] integerValue];
    }
    
    return self;
}

#pragma mark - properties

-(NSData *)gameData{
    NSDictionary * gameDataDict = @{@"target" : @(self.moneyholeTarget)};
    NSError * error = nil;
    NSData * gameData = [NSPropertyListSerialization dataWithPropertyList:gameDataDict
                                                                   format:NSPropertyListBinaryFormat_v1_0
                                                                  options:0
                                                                    error:&error];
    return gameData;
}

-(NSString *)moneyholeTargetPercentageString{
    double targetPercentage = ((double)self.moneyholeTarget/(double)MONEY_HOLE_MAX_SCORE) * 100;
    return [NSString stringWithFormat:@"%0.0f%%",targetPercentage];
}

-(NSString *)moneyholeScorePercentageString{
    return [NSString stringWithFormat:@"%0.02f%%",self.moneyholeScorePercentage * 100];
}

-(double)moneyholeScorePercentage{
    return ((double)self.moneyholeScore / (double)MONEY_HOLE_MAX_SCORE);
}

-(void)setMoneyholeScore:(NSUInteger)moneyholeScore{
    [self willChangeValueForKey:@"moneyholeScorePercentage"];
    _moneyholeScore = moneyholeScore;
    [self didChangeValueForKey:@"moneyholeScorePercentage"];
}

-(NSInteger)smallbetScore{
    
    NSInteger difference = 0;
    
    //always be positive (mantra for life)
    if (self.moneyholeScore > self.moneyholeTarget) {
        difference = self.moneyholeScore - self.moneyholeTarget;
    }
    else{
        difference = self.moneyholeTarget - self.moneyholeScore;
    }
    
    NSInteger score = MONEY_HOLE_MAX_SCORE - difference;

    return score;
}

#pragma mark - instance methods

-(void)startFilling{
    if (self.timer) {
        return;
    }
    
    NSTimer * timer = [NSTimer timerWithTimeInterval:0.2
                                              target:self
                                            selector:@selector(fill)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer = timer;
}

-(void)fill{
    NSAssert(MONEY_HOLE_MAX_SCORE / 100 > 0, @"one hundreth of the max score should be more than 0");
    
    int amountToAdd = arc4random_uniform(MONEY_HOLE_MAX_SCORE / 50.0) + 50;
    
    if (self.moneyholeScore + amountToAdd > MONEY_HOLE_MAX_SCORE) {
        return;
    }
    self.moneyholeScore = self.moneyholeScore + amountToAdd;
}

-(void)stopFilling{
    [self.timer invalidate];
    self.timer = nil;
}

@end
