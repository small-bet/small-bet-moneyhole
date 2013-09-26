//
//  JDPMoneyEmitterView.m
//  MoneyHole
//
//  Created by Joel Parsons on 30/05/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPMoneyEmitterView.h"
#import <QuartzCore/QuartzCore.h>

@interface JDPMoneyEmitterView ()
@property (nonatomic, weak) CAEmitterLayer * emitterLayer;
@end

@implementation JDPMoneyEmitterView

+ (Class)layerClass
{
    //configure the UIView to have emitter layer
    return [CAEmitterLayer class];
}

#pragma mark - properties

- (void)setEmitting:(BOOL)emitting
{
    _emitting = emitting;
    self.emitterLayer.lifetime = emitting ? 1.0 : 0.0;
}

#pragma mark - lifecycle

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self setupEmitterLayer];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];

    if (self) {
        [self setupEmitterLayer];
    }

    return self;
}

-(void)setupEmitterLayer{
    // create emitter layer
    self.emitterLayer = (CAEmitterLayer*)self.layer;
    self.emitterLayer.seed = [[NSDate date] timeIntervalSince1970];
    self.emitterLayer.emitterPosition = CGPointMake(-15.0, 50.0);
    self.emitterLayer.emitterSize = CGSizeMake(26.0, 100.0);
    self.emitterLayer.emitterShape = kCAEmitterLayerLine;
    self.emitterLayer.emitterMode = kCAEmitterLayerPoints;
    self.emitterLayer.renderMode = kCAEmitterLayerUnordered;
    self.emitterLayer.lifetime = 0.0;

    CAEmitterCell *money = [CAEmitterCell emitterCell];
    NSString * imagePath = [[NSBundle mainBundle] pathForResource:@"dollar" ofType:@"png"];
    UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
    money.contents = (id)image.CGImage;
    money.color = [UIColor colorWithWhite:1.0 alpha:1.0].CGColor;
    //general
    money.birthRate = 30.0;
    money.lifetime = 1.70;
    money.scale = 0.15;
    money.scaleRange = 0.1;
    money.scaleSpeed = -0.01;
    money.spin = 0.0;
    money.spinRange = 3.0;
    //physics
    money.velocity = 520.0;
    money.velocityRange = 50.0;
    money.xAcceleration = -110.0;
    money.yAcceleration = 797.0;
    money.emissionLatitude = 3.84;
    money.emissionLongitude = 2.1;

    //color
    money.greenRange = 0.1;

    [money setName:@"money"];
    self.emitterLayer.emitterCells = @[money];
}

@end
