//
//  JDPFingerGestureRecognizer.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPFingerGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface JDPFingerGestureRecognizer ()
// readonly for users of a gesture recognizer. may only be changed by direct subclasses of UIGestureRecognizer
@property(nonatomic,readwrite) UIGestureRecognizerState state;  // the current state of the gesture recognizer. can only be set by subclasses of UIGestureRecognizer, but can be read by consumers
// the following methods are to be overridden by subclasses of UIGestureRecognizer
// if you override one you must call super

// called automatically by the runtime after the gesture state has been set to UIGestureRecognizerStateEnded
// any internal state should be reset to prepare for a new attempt to recognize the gesture
// after this is received all remaining active touches will be ignored (no further updates will be received for touches that had already begun but haven't ended)
- (void)reset;


@end

@implementation JDPFingerGestureRecognizer

-(void)reset{
    [super reset];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.state == UIGestureRecognizerStatePossible) {
        self.state = UIGestureRecognizerStateBegan;
        return;
    }
    
    for (UITouch * touch in touches) {
        [self ignoreTouch:touch forEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    self.state = UIGestureRecognizerStateChanged;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.state = UIGestureRecognizerStateEnded;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    self.state = UIGestureRecognizerStateCancelled;
}

@end

