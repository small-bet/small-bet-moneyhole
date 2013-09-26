//
//  JDPGameViewController.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPGameViewController.h"
#import "JDPGame.h"
#import <SmallBet/SmallBet.h>
#import "JDPFingerGestureRecognizer.h"
#import "JDPGameEndViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JDPMainViewController.h"
#import "JDPMoneyEmitterView.h"

@interface JDPGameViewController ()
<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetPercentageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *moneyImageView;
@property (weak, nonatomic) IBOutlet UIProgressView *endGameProgressView;
@property (weak, nonatomic) IBOutlet JDPMoneyEmitterView *moneyEmitterView;

@property (nonatomic) CGFloat maxMoneyViewHeight;

@property (nonatomic, weak) NSTimer * helpTimer;
@property (nonatomic, weak) NSTimer * gameEndTimer;

@property (nonatomic, strong) UIViewController * currentViewController;
@property (nonatomic, strong) NSMutableArray * observers;

@end

@implementation JDPGameViewController

#pragma mark - properties

-(NSMutableArray *)observers{
    if (_observers) {
        return _observers;
    }

    _observers = [[NSMutableArray alloc] initWithCapacity:1];
    return _observers;
}

#pragma mark - lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    if (self.challenge) {
        self.game = [[JDPGame alloc] initWithGameData:self.challenge.gameConfiguration];
    }
    
    JDPFingerGestureRecognizer * gestureRecognizer = [[JDPFingerGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(gestureRecognized:)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    self.maxMoneyViewHeight = self.moneyImageView.frame.size.height;
    [self setMoneyViewFrameForScore:self.game.moneyholeScorePercentage animated:NO];
    
    self.helpLabel.alpha = 0.0;
    self.scoreLabel.alpha = 0.0;
    
    self.endGameProgressView.alpha = 0.0;
    self.endGameProgressView.layer.speed = 0.1;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.targetPercentageLabel.text = self.game.moneyholeTargetPercentageString;
    
    [self.game addObserver:self
                forKeyPath:@"moneyholeScorePercentage"
                   options:NSKeyValueObservingOptionNew
                   context:NULL];


    id backgroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification
                                                                              object:nil
                                                                               queue:[NSOperationQueue mainQueue]
                                                                          usingBlock:^(NSNotification *note) {
                                                                              [self resetGameEndTimer];
                                                                          }];

    id foregroundObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                                              object:nil
                                                                               queue:[NSOperationQueue mainQueue]
                                                                          usingBlock:^(NSNotification *note) {
                                                                              [self endGame];
                                                                          }];
    id resignActiveObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillResignActiveNotification
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue]
                                                                            usingBlock:^(NSNotification *note) {
                                                                                [self resetGameEndTimer];
                                                                            }];

    id becomeActiveObserver = [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                                                object:nil
                                                                                 queue:[NSOperationQueue mainQueue]
                                                                            usingBlock:^(NSNotification *note) {
                                                                                [self startGameEndTimer];
                                                                            }];

    [self.observers addObjectsFromArray:@[backgroundObserver, foregroundObserver, resignActiveObserver, becomeActiveObserver]];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    NSTimer * helpTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0]
                                                   interval:0
                                                     target:self
                                                   selector:@selector(showHelpText)
                                                   userInfo:nil
                                                    repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:helpTimer forMode:NSRunLoopCommonModes];
    self.helpTimer = helpTimer;
}

-(void)viewWillDisappear:(BOOL)animated{
    for (id observer in self.observers) {
        [[NSNotificationCenter defaultCenter] removeObserver:observer];
    }
    self.observers = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - moneyView

-(void)setMoneyViewFrameForScore:(double)score animated:(BOOL)animated{
    CGFloat moneyviewHeight = self.maxMoneyViewHeight * score;
    
    CGRect moneyViewFrame = self.moneyImageView.frame;
    moneyViewFrame.origin.y = CGRectGetHeight(self.view.bounds) - moneyviewHeight;
    moneyViewFrame.size.height = moneyviewHeight;
    
    if (animated) {
        UIViewAnimationOptions option = UIViewAnimationOptionCurveLinear | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options:option
                         animations:^{
                             self.moneyImageView.frame = moneyViewFrame;
                         }
                         completion:^(BOOL finished) {
                             
                         }];
    }else{
        self.moneyImageView.frame = moneyViewFrame;
    }
}

#pragma mark - help text

-(void)showHelpText{
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.helpLabel.alpha = 1.0;
                     }
                     completion:^(BOOL finished) {
                         UIViewAnimationOptions opts = UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat;
                         [UIView animateWithDuration:0.6
                                               delay:0.0
                                             options:opts
                                          animations:^{
                                              self.helpLabel.alpha = 0.4;
                                          }
                                          completion:^(BOOL finished) {
                                              
                                          }];
                     }];
}

-(void)hideHelpText{
    [self.helpTimer invalidate];
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.helpLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - game play

-(void)startFilling{
    self.moneyEmitterView.emitting = YES;
    [self resetGameEndTimer];
    [self hideHelpText];

    double delayInSeconds = 1.0 + (0.2 * (1 - self.game.moneyholeScorePercentage));
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.game startFilling];
    });
}


-(void)stopFilling{
    self.moneyEmitterView.emitting = NO;
    [self startGameEndTimer];

    double delayInSeconds = 1.0 + (0.2 * (1 - self.game.moneyholeScorePercentage));
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.game stopFilling];
    });

}

#pragma mark - game end

-(void)startGameEndTimer{
    if (self.gameEndTimer) {
        return;
    }

    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:kNilOptions
                     animations:^{
                        self.endGameProgressView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         if (self.gameEndTimer) {
                             //check the timer didnt get reset
                             [self.endGameProgressView setProgress:1.0 animated:YES];
                         }
                     }];
    
    
    NSTimer * timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:3.2]
                                               interval:0
                                                 target:self
                                               selector:@selector(endGame)
                                               userInfo:nil
                                                repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    self.gameEndTimer = timer;

}

-(void)resetGameEndTimer{
    [self.gameEndTimer invalidate];
    self.gameEndTimer = nil;
    self.endGameProgressView.alpha = 0.0;
    [self.endGameProgressView setProgress:0.0 animated:NO];

}

-(void)endGame{
    JDPGameEndViewController * gameEndViewController = [[JDPGameEndViewController alloc] init];
    gameEndViewController.challenge = self.challenge;
    [self.game stopFilling];
    gameEndViewController.game = self.game;
    
    if ([self.parentViewController respondsToSelector:@selector(crossfadeToViewController:)]) {
        [(id)self.parentViewController crossfadeToViewController:gameEndViewController];
    }
}

#pragma mark - target action

-(void)gestureRecognized:(UIGestureRecognizer *)sender{
    
    switch (sender.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self stopFilling];
            break;
        
        case UIGestureRecognizerStateBegan:
            [self startFilling];
            break;
        case UIGestureRecognizerStateChanged:
            break;
        case UIGestureRecognizerStatePossible:
        default:
            break;
    }
}

#pragma mark - KVO

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if ([keyPath isEqualToString:@"moneyholeScorePercentage"]) {
        [self setMoneyViewFrameForScore:self.game.moneyholeScorePercentage animated:YES];
    }
}

@end
