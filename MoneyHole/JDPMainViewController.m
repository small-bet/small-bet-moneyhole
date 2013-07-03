//
//  JDPMainViewController.m
//  MoneyHole
//
//  Created by Joel Parsons on 25/04/2013.
//  Copyright (c) 2013 Small Bet. All rights reserved.
//

#import "JDPMainViewController.h"
#import "JDPMenuViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface JDPMainViewController ()

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *cloudImageViews;
@property (weak, nonatomic) IBOutlet UIView *cloudContainerView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) NSDictionary * animations;
@property (nonatomic, strong) NSMutableArray * observers;

//UIViewController containment
@property (nonatomic, strong) UIViewController * currentViewController;
@end

@implementation JDPMainViewController

-(NSMutableArray *)observers{
    if (_observers) {
        return _observers;
    }

    _observers = [NSMutableArray array];
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

    [self animateClouds];

    self.cloudContainerView.alpha = 0.0;

    id observer = [[NSNotificationCenter defaultCenter]
                   addObserverForName:UIApplicationDidEnterBackgroundNotification
                   object:nil
                   queue:[NSOperationQueue mainQueue]
                   usingBlock:^(NSNotification *note) {
                       self.cloudContainerView.alpha = 0.0;
                   }];
    [self.observers addObject:observer];

    observer = [[NSNotificationCenter defaultCenter]
                addObserverForName:UIApplicationWillEnterForegroundNotification
                object:nil
                queue:[NSOperationQueue mainQueue]
                usingBlock:^(NSNotification *note) {
                    [self animateClouds];
                    [self fadeInCloudsWithDelay:0.3];
                }];

    [self.observers addObject:observer];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (self.currentViewController == nil) {
        JDPMenuViewController * menuViewController = [[JDPMenuViewController alloc] initWithNibName:nil bundle:nil];
        [self addChildViewController:menuViewController];
        self.currentViewController = menuViewController;
        menuViewController.view.alpha = 0;
        menuViewController.view.frame = self.containerView.bounds;
        [self.containerView addSubview:menuViewController.view];
        
        menuViewController.view.layer.rasterizationScale = [UIScreen mainScreen].scale;
        menuViewController.view.layer.shouldRasterize = YES;

        [UIView animateWithDuration:1.0
                              delay:0.8
                            options:UIViewAnimationCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             menuViewController.view.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             [menuViewController didMoveToParentViewController:self];
                             menuViewController.view.layer.shouldRasterize = NO;
                         }];
        [self fadeInCloudsWithDelay:0.0];
    }
}

-(void)dealloc{
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


#pragma mark - JDPMainViewController

-(void)animateClouds{
    for (UIImageView * cloud in self.cloudImageViews) {

        NSTimeInterval animationDuration = 20.0 + arc4random_uniform(15);
        CGFloat initialDirection = powf(-1.0, arc4random_uniform(2));
        CGFloat movementInPixels = 20.0 + arc4random_uniform(30);

        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                         animations:^{
                             CGFloat movement = movementInPixels * initialDirection;
                             cloud.transform = CGAffineTransformMakeTranslation(movement, 0);
                             cloud.transform = CGAffineTransformMakeTranslation(-movement, 0);
                         }
                         completion:^(BOOL finished) {

                         }];
    }
}

-(void)fadeInCloudsWithDelay:(NSTimeInterval)delay{
    [UIView animateWithDuration:0.6
                          delay:delay
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.cloudContainerView.alpha = 1.0;
                     } completion:^(BOOL finished) {

                     }];
}

#pragma mark - UIViewControllerContainment

-(void)crossfadeToViewController:(UIViewController *)newViewController{
    NSParameterAssert(newViewController);
    
    if (self.currentViewController == nil) {
        return;
    }
    
    [self addChildViewController:newViewController];
    [self.currentViewController willMoveToParentViewController:nil];
    
    UIViewController * oldViewController = self.currentViewController;
    self.currentViewController = newViewController;
    
    newViewController.view.frame = self.containerView.bounds;
    newViewController.view.alpha = 0;
        
    [self transitionFromViewController:oldViewController
                      toViewController:newViewController
                              duration:1.0
                               options:UIViewAnimationOptionCurveEaseInOut
                            animations:^{
                                oldViewController.view.alpha = 0;
                                newViewController.view.alpha = 1.0;
                            } completion:^(BOOL finished) {
                                [newViewController didMoveToParentViewController:self];
                            }];
}

@end
